class IndexView {
  constructor() {
    this.username = document.getElementById("username").value;
    this.gameCode = document.getElementById("game-code").value;

    this.initComponents();
    this.initWebSocket();
  }

  initComponents() {

  }

  initWebSocket() {
    this.socket = new WebSocket(`ws://${window.location.host}/join/${this.hostName}`);

    this.socket.onmessage = (event) => {
        const message = JSON.parse(event.data);
        this.handleStatusChange(message);
    }
  }
}
