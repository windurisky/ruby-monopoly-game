class IndexView {
  constructor() {
    this.initComponents();
    this.initWebSocket();
  }

  initComponents() {
    this.username = document.getElementById("username");
    this.joinRoom = document.getElementById("join-room");
    this.createRoom = document.getElementById("create-room");

    this.joinRoom.addEventListener("click", () => {
      console.log(this.username.value);
      this.socket.send(JSON.stringify({
        action: "join_room",
        username: this.username.value,
        game_code: location.pathname.split('/')[2]
      }));
    });
  }

  initWebSocket() {
    this.socket = new WebSocket(`ws://${window.location.host}`);

    this.socket.onmessage = (event) => {
        const message = JSON.parse(event.data);
        console.log(message);
        this.handleWebSocketChange(message);
    }
  }

  handleWebSocketChange(message) {
    if (message.action === "join_room") {
      this.navigateToGame();
    } else if (message.action === "create_room") {
      this.navigateToGame();
    }
  }

  navigateToGame() {
    // logic proceed to game
  }
}

window.onload = () => {
    new IndexView();
};
