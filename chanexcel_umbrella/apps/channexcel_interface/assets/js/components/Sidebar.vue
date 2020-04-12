<template>
    <div class="row flex-xl-nowrap2">
        <div class="border-view col-md-3 col-xl-2 col-12 h1">
            <label :class="registerInput" class="name-label">Enter User Name:</label>
            <input id="userName" :class="registerInput" style="margin-top: 10px;" :disabled="validated == true" v-model="userName" type="text"/>
            <b-button class="side-buttons btn-primary" style="margin-top: 10px;" :disabled="validated == true" variant="primary" @click="register()">Register</b-button>
            <div :disabled="validated == 0">
                <label>Enter Channel Name:</label>
                <input id="channelName" style="margin-top: 10px;" v-model="chanName" :disabled="validated == false" @keyup="createChannelName()" type="text"/>
                <b-button class="side-buttons btn-primary" style="margin-top: 10px;" :disabled="validated == false" variant="primary" @click="new_channel()">New Channel</b-button>
                <select class="custom-select custom-select-lg mb-3 channel-select" :disabled="validated == false" style="font-size: 16pt;" multiple size="5">
                    <option v-for="channel in channelList" :value="channel.value">{{ channel.text }}</option>
                    </select>
            
                <b-button class="side-buttons btn-primary" style="margin-top: 10px;" :disabled="validated == 0" variant="primary" @click="join_channel('otherGalil')">Join Channel</b-button>         
            </div>
        </div>
        <div class="main-view col-md-9 col-xl-8 col-12 pd-md-3 pl-md-5">
            <div class="vue-message">
                <div v-if="showJoined">{{ joinedChannel }}</div>
                <br>
                <div>
                    <label>Convo Area</label> 
                    <b-form-textarea readonly
                      id="textarea"
                      class="convo-text"
                      v-model="totalMessage"
                      placeholder=""
                      lazy-formatter
                      :formatter="formatter"
                      rows="20"
                      max-rows="6"
                    ></b-form-textarea>
                    <br>
                    <b-form-textarea
                      id="textarea"
                      v-model="nextMessage"
                      placeholder="Enter something..."
                      rows="3"
                      max-rows="6"
                      @keyup.enter="sendMessage()"
                    ></b-form-textarea>
                
                    <pre class="mt-3 mb-0">{{ nextMessage }}</pre>
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
            joinedChannel: '',
            userName: '',
            showJoined: false,
            socket: s,
            channel: null,
            channelList: [],
            chanName: '',
            totalMessage: '',
            nextMessage: '',
            messageFeed: [],
            validated: false,
            register_error: false
        }
    },
    computed: {
        registerInput: function () {
            return this.register_error ? 'reg-error' : '';
        }
    },
    methods: {
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
        sendMessage(){
            // this.totalMessage += '\n';
            // this.totalMessage += this.nextMessage;
            this.room_message(this.channel, this.nextMessage);
            this.nextMessage = '';
        },
        receive_message(sender, message) {
            this.totalMessage += sender + ": " + message;
        },
        join_channel(chan=this.chanName, name) {
            var socket = new Phoenix.Socket("/socket", {})
            socket.connect()
            // var channel = socket.channel("tool:" + this.chanName, {name: this.chanName, user_type: "dev"})
            this.channel = socket.channel("tool:" + chan, {name: name, user_type: "dev"})
            this.joinedChannel = "Joined Channel: " + chan + "!";
            console.log(this.join(this.channel));
            this.channel.on("generic_message", res => this.receive_message(res.sender, res.message));
            this.showJoined = true;
            // console.log(this.join(channel))
        },
        new_channel(chanName=this.chanName) {
            var new_chan = {value: chanName, text: chanName}
            this.channelList.push(new_chan);
            this.join_channel(chanName);
            this.new_quotetool(this.channel, chanName, "dev");
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
        },
        room_message(channel,  msg) {
            channel.push("room_message", {sender: this.userName, message:msg})
            .receive("error", res => { console.log("erroring")})
            .receive("ok", res => {console.log("did it good", res)})
        },
        formatter(value) {
            return value.toLowerCase();
        },
        register() {
            if (this.userName === ''){
                this.register_error = true;
            } else{
                // this.new_channel(this.userName + ' (Self)')

                var new_chan = {value: this.userName, text: this.userName + ' (Self)'}
                this.channelList.push(new_chan);
                this.join_channel(this.userName, this.userName);
                this.new_quotetool(this.channel, this.userName , "dev");
                this.validated = true;
            }
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
    .text-area{
        border: none;
    }
    .convo-text{
        font-size: 15pt !important;
    }
    .name-label{
        color: black;
    }
    .reg-error {
        border-color: red !important;
        color: red;
    }
</style>
