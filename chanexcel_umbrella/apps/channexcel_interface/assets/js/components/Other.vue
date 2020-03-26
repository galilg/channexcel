  <template>
    <div class="vue-message">
        <!-- <div>{{ message }}</div> -->
        <span v-bind:title="message">
          Hover your mouse over me for a few seconds to see my dynamically bound title!
        </span>
        <img v-bind:src="image">
        <li v-for="todo in todos">
            {{ todo.text }}
        </li>
    </div>
  </template>

<script>
export default {
    data() {
      return {
        message: 'You loaded this on ' + new Date().toLocaleString(),
        image: 'https://d36tnp772eyphs.cloudfront.net/blogs/1/2019/10/seljalandsfoss-most-instagrammed-waterfalls-world.jpg',
        todos: [
            { text: "Ok" },
            { text: "Now something"}
        ]
        }
    }
}
</script>
  
<style>
    .vue-message {
      text-align: center;
      font-size: 2em;
    }
</style>