
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


function new_tool(channel, name, user_type) {
channel.push("new_tool", {name: name, user_type: user_type})
    .receive("ok", response => {
        console.log("New quote tool!", response)
})
    .receive("error", response => {
        console.log("Unable to start a new quote tool :(", response)
})
}

function send_dir(channel, name, msg) {
    channel.push("direct_message", {receiver: name, message: msg})
    .receive("error", res => { console.log("cant do")})
    .receive("ok", res => {console.log("did it", res)})
}

function room_message(channel, msg) {
    channel.push("room_message", msg)
    .receive("error", res => { console.log("erroring")})
    .receive("ok", res => {console.log("did it good", res)})
}


var socket = new Phoenix.Socket("/socket", {})

socket.connect()

var user1 = new_channel("Galil", "dev")

join(user1)

user1.on("user_added", response => {
	console.log("User Added", response)
})

new_tool(user1, "Galil", "dev")

user1.on("direct_message:Galil", res => {console.log(res.message)})

user1.on("generic_message", res => {console.log(res.message)})

send_dir(user1, "Other", "Hello other, if that is who you are!")
