class IndexView {
  constructor() {
    this.initComponents();
    this.initWebSocket();

  }

  initComponents() {
    // do something
  }

  initWebSocket() {
    this.socket = new WebSocket(`ws://${window.location.host}`);

    this.socket.onmessage = (event) => {
      const data = JSON.parse(event.data);
      console.log(data);
      this.handleWebSocketChange(data);
    }

    this.socket.onopen = (event) => {
      this.connect_room();
    }
  }

  handleWebSocketChange(data) {
    if (data.action === "connect_room") {
      this.setCookie('ruby_monopoly_user_id', data.user_id);
      this.setCookie('ruby_monopoly_username', data.username);
      this.setCookie('ruby_monopoly_room_code', data.code);
    }
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

  getCookie(name) {
    var match = document.cookie.match(new RegExp('(^| )' + name + '=([^;]+)'));
    if (match) return match[2];
  }

  connect_room() {
    this.user_id = this.getCookie('ruby_monopoly_user_id');
    this.username = this.getCookie('ruby_monopoly_username');
    this.room_code = this.getCookie('ruby_monopoly_room_code');
    console.log('trying to connect to game room');
    console.log(`${this.user_id} ${this.username} ${this.room_code}`);
    this.socket.send(JSON.stringify({
      action: "connect_room",
      user_id: this.user_id,
      username: this.username,
      room_code: this.room_code
    }));
  }
}

window.onload = () => {
    new IndexView();
};
