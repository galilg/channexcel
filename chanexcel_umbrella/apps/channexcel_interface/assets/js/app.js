// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
// import css from "../css/app.css"
const _css = require("../css/app.css");

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import "phoenix"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
import Vue from "vue";
import Message from "./components/Message.vue";
import Other from "./components/Other.vue";
import Sidebar from "./components/Sidebar.vue";

import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

// var socket = new Phoenix.Socket("/socket", {})

// Install BootstrapVue
Vue.use(BootstrapVue)
// Optionally install the BootstrapVue icon components plugin
Vue.use(IconsPlugin)

// socket.connect()


// function new_channel(name, user_type) {
//   return socket.channel("tool:" + name, {name: name, user_type: user_type});
// }


// function join(channel) {
//   channel.join()
//   .receive("ok", res => {
//     console.log("joined successfully!", res)
//   })
//   .receive("error", res => {
//     console.log("Unable to join", res)
//   })
// }


// function leave(channel) {
//   channel.leave()
//   .receive("ok", res => {
//     console.log("Left successfully", res)
//   })
//   .receive("error", res => {
//     console.log("You cannot ever leave.", res)
//   })
// } 


// function add_user(channel, name, user_type) {
//   channel.push("add_user", {name: name, user_type: user_type})
// 	.receive("error", res => {
// 		console.log("Unable to add new user")})
// }


var sidebar = new Vue({
    render: h=>h(Sidebar)
}).$mount("#side-bar")

// var otherApp = new Vue({
//     render: h => h(Message)
//   }).$mount("#hello")


// var app = new Vue({
//     render: s => s(Other)
//   }).$mount("#app-2")