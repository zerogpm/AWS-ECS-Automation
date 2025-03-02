import FriendList from "./FriendList";
import FormAddFriend from "./FormAddFriend";
import Button from "./Button";
import FormSplitBills from "./FormSplitBills";
import { useState } from "react";

const initialFriends = [
  {
    id: 118836,
    name: "Clark",
    image: "https://i.pravatar.cc/48?u=118836",
    balance: -7,
  },
  {
    id: 933372,
    name: "Sarah",
    image: "https://i.pravatar.cc/48?u=933372",
    balance: 20,
  },
  {
    id: 499476,
    name: "Anthony",
    image: "https://i.pravatar.cc/48?u=499476",
    balance: 0,
  },
];

function App() {
  const [showFormSplitBills, setShowFormsplitBills] = useState(false);
  const [friends, setFriends] = useState(initialFriends);
  const [selectedFriend, setSelectedFriend] = useState(null);

  function handleButtonClick() {
    setShowFormsplitBills((show) => !show);
  }

  function handleAddFriend(newFriend) {
    setFriends((currentFriends) => [...currentFriends, newFriend]);
    setShowFormsplitBills(false);
  }

  function handleSelectFriend(friend) {
    setSelectedFriend((cur) => (cur?.id === friend.id ? null : friend));
  }

  function handleSplitBill(value) {
    setFriends((friends) =>
      friends.map((friend) =>
        friend.id === selectedFriend.id ? { ...friend, balance: value } : friend
      )
    );
    setSelectedFriend(null);
  }

  return (
    <div className="app">
      <div className="sidebar">
        <FriendList
          initialFriends={friends}
          onSelection={handleSelectFriend}
          selectedFriend={selectedFriend}
        />

        {showFormSplitBills && <FormAddFriend onAddFriends={handleAddFriend} />}
        <Button onClick={handleButtonClick}>
          {showFormSplitBills ? "Close" : "Add Friend"}
        </Button>
      </div>

      {selectedFriend && (
        <FormSplitBills
          key={selectedFriend.id}
          selectedFriend={selectedFriend}
          onSplitBill={handleSplitBill}
        />
      )}
    </div>
  );
}

export default App;
