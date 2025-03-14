import { useState, useEffect } from "react";
import FriendsList from "./FriendsList";
import AddFriendForm from "./AddFriendForm";
import SplitBillForm from "./SplitBillForm";

function App() {
  const [friends, setFriends] = useState([]);
  const [selectedFriend, setSelectedFriend] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    async function fetchFriends() {
      setIsLoading(true);
      setError("");

      try {
        console.log("Fetching friends from API");

        // Using relative URL - Nginx will proxy this to the backend
        const response = await fetch("/api/friends");
        console.log("Response status:", response.status);

        if (!response.ok) {
          throw new Error("Something went wrong with fetching friends");
        }

        const data = await response.json();
        console.log("Response data:", data);
        setFriends(data);
      } catch (err) {
        console.error(err.message);
        setError("Failed to load friends. Please try again later.");
      } finally {
        setIsLoading(false);
      }
    }

    fetchFriends();
  }, []);

  async function handleAddFriend(friend) {
    try {
      // Using relative URL
      const response = await fetch("/api/friends", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(friend),
      });

      if (!response.ok) {
        throw new Error("Failed to add friend");
      }

      const newFriend = await response.json();
      setFriends((friends) => [...friends, newFriend]);
    } catch (err) {
      console.error(err.message);
      setError("Failed to add friend. Please try again.");
    }
  }

  async function handleSplitBill(value) {
    try {
      // Using relative URL
      const response = await fetch(`/api/friends/${selectedFriend.id}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ balance: selectedFriend.balance + value }),
      });

      if (!response.ok) {
        throw new Error("Failed to update balance");
      }

      const updatedFriend = await response.json();

      setFriends((friends) =>
        friends.map((friend) =>
          friend.id === selectedFriend.id ? updatedFriend : friend
        )
      );

      setSelectedFriend(null);
    } catch (err) {
      console.error(err.message);
      setError("Failed to update balance. Please try again.");
    }
  }

  function handleSelection(friend) {
    setSelectedFriend((curr) => (curr?.id === friend.id ? null : friend));
  }

  return (
    <div className="app">
      <div className="sidebar">
        {error && (
          <p style={{ color: "red", fontSize: "1.4rem", marginBottom: "1rem" }}>
            {error}
          </p>
        )}
        {isLoading && (
          <p style={{ fontSize: "1.4rem", marginBottom: "1rem" }}>
            Loading friends...
          </p>
        )}

        <FriendsList
          friends={friends}
          selectedFriend={selectedFriend}
          onSelection={handleSelection}
        />

        <AddFriendForm onAddFriend={handleAddFriend} />
      </div>

      {selectedFriend && (
        <SplitBillForm
          selectedFriend={selectedFriend}
          onSplitBill={handleSplitBill}
          key={selectedFriend.id}
        />
      )}
    </div>
  );
}

export default App;
