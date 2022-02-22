class IndexView {
  constructor() {
    this.initComponents();
    this.initWebSocket();
  }

  initComponents() {
    this.username = document.getElementById("username");
    this.roomCode = document.getElementById("game-code");
    this.joinRoom = document.getElementById("join-room");
    this.createRoom = document.getElementById("create-room");

    this.joinRoom.addEventListener("click", () => {
      console.log(this.username.value);
      console.log(this.roomCode.value);
      this.socket.send(JSON.stringify({
        action: "join_room",
        username: this.username.value,
        room_code: this.roomCode.value
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
      const data = JSON.parse(event.data);
      console.log(data);
      this.handleWebSocketChange(data);
    }
  }

  handleWebSocketChange(data) {
    switch (data.action) {
      case "join_room":
      case "create_room":
        this.setCookie('ruby_monopoly_user_id', data.user_id, 7);
        this.setCookie('ruby_monopoly_username', data.username, 7);
        this.setCookie('ruby_monopoly_room_code', data.code, 7);
        console.log('cookies are set');
        this.navigateToGame();
        break;
    }
  }

  navigateToGame() {
    window.location = `http://${window.location.host}/room`;
  }

  setCookie(name, value, days) {
    var expires = "";
    if (days) {
      var date = new Date();
      date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
      expires = "; expires=" + date.toUTCString();
    }
    const cookieString = name + "=" + (value || "") + expires + "; path=/";
    document.cookie = cookieString;
    console.log(cookieString);
  }
}

window.onload = () => {
    new IndexView();
};
