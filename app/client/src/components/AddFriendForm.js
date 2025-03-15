import { useState } from "react";
import { v4 as uuidv4 } from "uuid";

function AddFriendForm({ onAddFriend }) {
  const [name, setName] = useState("");
  const [image, setImage] = useState("https://i.pravatar.cc/48");

  // Debug logs to check environment when component loads
  console.log("[Debug] Using dedicated UUID library instead of crypto");

  function handleSubmit(e) {
    e.preventDefault();
    console.log("[Debug] Form submitted");

    if (!name) {
      console.log("[Debug] Name is empty, skipping submission");
      return;
    }

    try {
      // Use the UUID library to generate a unique ID
      const id = uuidv4();
      console.log("[Debug] Created ID using uuid library:", id);

      const newFriend = {
        id,
        name,
        image: `${image}?u=${id}`,
        balance: 0,
      };
      console.log("[Debug] New friend object:", newFriend);

      onAddFriend(newFriend);
      console.log("[Debug] Friend added successfully");
      setName("");
    } catch (error) {
      console.error("[Debug] Error in submission:", error);
    }
  }

  return (
    <form className="form-add-friend" onSubmit={handleSubmit}>
      <label>👫 Friend name</label>
      <input
        type="text"
        value={name}
        onChange={(e) => setName(e.target.value)}
      />

      <label>🌄 Image URL</label>
      <input
        type="text"
        value={image}
        onChange={(e) => setImage(e.target.value)}
      />

      <button className="button">Add</button>
    </form>
  );
}

export default AddFriendForm;
