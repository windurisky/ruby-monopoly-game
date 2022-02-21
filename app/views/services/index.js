class IndexView {
  constructor() {
    this.initComponents();
    this.initWebSocket();
  }

  initComponents() {
    this.username = document.getElementById("username");
    this.gameCode = document.getElementById("game-code");
    this.joinRoom = document.getElementById("join-room");
    this.createRoom = document.getElementById("create-room");

    this.joinRoom.addEventListener("click", () => {
      console.log(this.username.value);
      console.log(this.gameCode.value);
      this.socket.send(JSON.stringify({
        action: "join_room",
        username: this.username.value,
        game_code: this.gameCode.value
      }));
    });
    this.createRoom.addEventListener("click", () => {
      console.log(this.username.value);
      this.socket.send(JSON.stringify({
        action: "create_room",
        username: this.username.value,
      }));
    });
  }

  initWebSocket() {
    this.socket = new WebSocket(`ws://${window.location.host}`);

    this.socket.onmessage = (event) => {
        const message = JSON.parse(event.data);
        this.handleWebSocketChange(message);
    }
  }

  handleWebSocketChange(message) {
    if (message.action === "join") {

    } else if (message.action === "start") {
      this.navigateToGame();
    } else if (message.action === "fail_join") {
      this.$startGame.disabled = true;
      this.$startGame.innerText = "Navigating back... Create your own game!";
      this.$newGameNotice.innerText = "4 Players Max Per Game!";
      this.$newGameNotice.style.color = "#F44336";
      setTimeout(this.navigateBack, 2000);
    }
  }
}

window.onload = () => {
    new IndexView();
};
