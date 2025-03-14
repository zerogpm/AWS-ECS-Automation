const express = require("express");
const cors = require("cors");
const fs = require("fs").promises;
const path = require("path");

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(
  cors({
    origin: "*", // Or specify your frontend origin like 'http://your-frontend-domain'
    credentials: false,
    methods: ["GET", "POST", "PATCH"],
  })
);
app.use(express.json());

// Add logging middleware to help with debugging
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  console.log("Headers:", JSON.stringify(req.headers, null, 2));
  next();
});

// Helper function to read friends data
async function readFriendsData() {
  try {
    const data = await fs.readFile(
      path.join(__dirname, "data", "friends.json"),
      "utf8"
    );
    return JSON.parse(data);
  } catch (error) {
    console.error("Error reading friends data:", error);
    return [];
  }
}

// Helper function to write friends data
async function writeFriendsData(friends) {
  try {
    await fs.writeFile(
      path.join(__dirname, "data", "friends.json"),
      JSON.stringify(friends, null, 2),
      "utf8"
    );
    return true;
  } catch (error) {
    console.error("Error writing friends data:", error);
    return false;
  }
}

// GET all friends
app.get("/api/friends", async (req, res) => {
  try {
    console.log("Received request for /api/friends");
    const friends = await readFriendsData();
    console.log("Read friends data:", friends);
    res.json(friends);
  } catch (error) {
    console.error("Error serving friends data:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
});

// POST a new friend
app.post("/api/friends", async (req, res) => {
  try {
    const friends = await readFriendsData();
    const newFriend = req.body;

    // Ensure the new friend has all required fields
    if (!newFriend.id || !newFriend.name || !newFriend.image) {
      return res.status(400).json({ message: "Missing required fields" });
    }

    friends.push(newFriend);
    await writeFriendsData(friends);

    res.status(201).json(newFriend);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
});

// PATCH to update friend balance
app.patch("/api/friends/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { balance } = req.body;

    if (balance === undefined) {
      return res.status(400).json({ message: "Balance is required" });
    }

    const friends = await readFriendsData();
    const friendIndex = friends.findIndex((friend) => friend.id === id);

    if (friendIndex === -1) {
      return res.status(404).json({ message: "Friend not found" });
    }

    friends[friendIndex].balance = balance;
    await writeFriendsData(friends);

    res.json(friends[friendIndex]);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
});

// Add health check endpoint for ECS health checks
app.get("/api/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
