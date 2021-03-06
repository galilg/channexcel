var socket = new Phoenix.Socket("/socket", {})

socket.connect()


function new_channel(name, user_type) {
  return socket.channel("tool:" + name, {name: name, user_type: user_type});
}


function join(channel) {
  channel.join()
  .receive("ok", res => {
    console.log("joined successfully!", res)
  })
  .receive("error", res => {
    console.log("Unable to join", res)
  })
}


function leave(channel) {
  channel.leave()
  .receive("ok", res => {
    console.log("Left successfully", res)
  })
  .receive("error", res => {
    console.log("You cannot ever leave.", res)
  })
} 


function add_user(channel, name, user_type) {
  channel.push("add_user", {name: name, user_type: user_type})
	.receive("error", res => {
		console.log("Unable to add new user")})
}

var user2 = new_channel("Galil", "ok")

join(user2)

user2.on("user_added", response => {
	console.log("User Added", response)
})

add_user(user2, "Other", "dev")

function send_dir(channel, name, msg) {
    channel.push("direct_message", {receiver: name, message: msg})
    .receive("error", res => { console.log("cant do")})
    .receive("ok", res => {console.log("did it", res)})
}

user2.on("direct_message:Other", res => {console.log(res.message)})

send_dir(user2, "Galil", "Hello.")




