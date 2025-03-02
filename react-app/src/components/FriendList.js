import Friend from "./Friend";

export default function FriendList({
  initialFriends,
  onSelection,
  selectedFriend,
}) {
  return (
    <ul className="friend-list">
      {initialFriends.map((friend) => (
        <Friend
          key={friend.id}
          friend={friend}
          onSelection={onSelection}
          selectedFriend={selectedFriend}
        />
      ))}
    </ul>
  );
}
