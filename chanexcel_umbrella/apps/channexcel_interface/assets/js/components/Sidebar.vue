<template>
    <div class="row flex-xl-nowrap2">
        <div class="border-view col-md-3 col-xl-2 col-12 h1">
            <label>Enter Channel Name:</label>
            <input id="channelName" style="margin-top: 10px;" v-model="chanName" @keyup="createChannelName()" type="text"/>
            <b-button class="side-buttons btn-primary" style="margin-top: 10px;" variant="primary" @click="new_channel()">New Channel</b-button>
            <select class="custom-select custom-select-lg mb-3 channel-select" style="font-size: 16pt;" multiple size="5">
                <option v-for="channel in channelList" :value="channel.value">{{ channel.text }}</option>
                </select>
        
            <b-button class="side-buttons btn-primary" style="margin-top: 10px;" variant="primary" @click="join_channel('otherGalil')">Join Channel</b-button>
        
                  
        </div>
        <div class="main-view col-md-9 col-xl-8 col-12 pd-md-3 pl-md-5">
            <div class="vue-message">
                <div v-if="showJoined">{{ joinedChannel }}</div>
              </div>
            </div>
        </div>
    </div>
</template>

<script>

var s = new Phoenix.Socket("/socket", {})

s.connect()

function new_channel(name, user_type) {
  return socket.channel("tool:" + name, {name: name, user_type: user_type});
}

export default {
    data() {
        return {
            active: true,
            joinedChannel: "",
            showJoined: false,
            socket: s,
            channel: null,
            channelList: [],
            chanName: ''
        }
    },
    methods: {
        // showJoined() {
        //     this.showMessage = true
        // }, 
        join(channel) {
            channel.join()
            .receive("ok", res => {
                console.log("joined successfully!", res)
            })
            .receive("error", res => {
                console.log("Unable to join", res)
            })
        },
        createChannelName(){
            console.log(this.chanName)
        },
        join_channel(name) {
            var socket = new Phoenix.Socket("/socket", {})
            socket.connect()
            // var channel = socket.channel("tool:" + this.chanName, {name: this.chanName, user_type: "dev"})
            this.channel = socket.channel("tool:" + this.chanName, {name: name, user_type: "dev"})
            this.joinedChannel = "Joined Channel: " + this.chanName + "!";
            console.log(this.join(this.channel))
            this.showJoined = true;
            // console.log(this.join(channel))
        },
        new_channel() {
            var new_chan = {value: this.chanName, text: this.chanName}
            this.channelList.push(new_chan);
            this.join_channel(this.chanName);
            this.new_quotetool(this.channel, this.chanName, "dev");
        },
        add_user(channel, name, user_type) {
            channel.push("add_user", {name: name, user_type: user_type})
                    .receive("error", res => {
                    console.log("Unable to add new user")})
        },
         send_dir(channel, name, msg) {
            channel.push("direct_message", {receiver: name, message: msg})
            .receive("error", res => { console.log("cant do")})
            .receive("ok", res => {console.log("did it", res)})
        },
        new_quotetool(channel, name, user_type) {
            channel.push("new_tool", {name: name, user_type: user_type})
                .receive("ok", response => {
                    console.log("New quote tool!", response)
            })
                .receive("error", response => {
                    console.log("Unable to start a new quote tool :(", response)
            })
        },
        send_dir(channel, name, msg) {
            channel.push("direct_message", {receiver: name, message: msg})
            .receive("error", res => { console.log("cant do")})
            .receive("ok", res => {console.log("did it", res)})
        }
    }
}
</script>

<style>
    .side-buttons {
        margin-top: 10px;
        margin-bottom: 10px;
        width: 75%;
        font-size: 13pt !important;
        border-radius: 5px !important;
    }
    .border-view {
        border-right-style: solid;
        border-radius: 0px;
        border-width: 1px;
        color: #E8E3E2;
        padding: 5px;
    }
    .join-or-new-channel {
        position: fixed;
        bottom: 0;
    }
    .channel-select{
        height: 350px !important;
        font-size: larger;
    }
</style>
