<template>
  <div id="app">
    <div v-show="$route.name!=='login'" class="sidebar">
      <ul>
        <li><router-link to="/menu"><img class="icon-sidebar" :src="require('./img/food.svg')" alt=""></router-link></li>
        <li><router-link to="/history"><img class="icon-sidebar" :src="require('./img/graph.svg')" alt=""></router-link></li>
        <li @click="showModal"><img class="icon-sidebar" :src="require('./img/more (1).svg')" alt=""></li>
        <li @click="logout"><img class="icon-sidebar" :src="require('./assets/logout.svg')" alt=""></li>
      </ul>
    </div>
    <div>
      <b-modal ref="my-modal" hide-footer title="Add Menu">
        <div class="d-block text-center">
          <div>
            <b-form-input style="margin-bottom: 25px;" v-model="food_name" placeholder="Enter food name"></b-form-input>
          </div>
          <div>
            <b-form-input style="margin-bottom: 25px;" v-model="food_price" placeholder="Enter food price"></b-form-input>
          </div>
          <div>
            <b-form-input style="margin-bottom: 25px;" v-model="food_image" placeholder="Enter food images"></b-form-input>
          </div>
          <div style="margin-bottom: 20px;">
            <b-form-select v-model="category" :options="options"></b-form-select>
          </div>
        </div>
        <b-button class="mt-2" style="border: none; background-color: #57CAD5; color: white; " block @click="addMenu">add Menu </b-button>
        <b-button class="mt-3" style="border: none; background-color: #F24F8A; color: white; "  block @click="hideModal">Cancel</b-button>
    </b-modal>
  </div>
    <router-view></router-view>
      
  </div>


</template>

<script>
import axios from "axios"
  

export default {
  name: 'App',
  components: {
  },
  data(){
  return {
     food_name: '',
     food_price: '',
     food_image: '',
     category : 'drink',
     options: [
          { value: 'drink', text: 'drink' },
          { value: 'cake', text: 'cake' },
          { value: 'food', text: 'food' },
        ],
      params : {
        name : '',
        price: '',
        category: '',
        image: ''
      }
      }
  },
  methods: {
      showModal() {
        this.$refs['my-modal'].show()
      },
      hideModal() {
        this.$refs['my-modal'].hide()
        this.reset()
      },
      addMenu() {
        this.postMenu(this.food_name, this.food_price, this.food_image, this.category)
        this.reset()
        this.$refs['my-modal'].hide()
      },
      reset(){
        this.food_name = '',
        this.food_price = '',
        this.food_image = ''
      },
      async postMenu(name, price, img, category_menu){
        parseInt(price)
        this.params.name = name
        this.params.price = price
        this.params.category = category_menu
        this.params.image = img
        await axios.post(process.env.VUE_APP_URL, this.params)
          .then((res) => {
                console.log(res.data)
                this.load()
            })
          .catch(error => {
                  console.log(error)
            });
      },
      load(){
        this.$router.go(this.$router.currentRoute)
    },
    logout(){
      localStorage.clear()
      this.$router.push('/')
    }
  },
  
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin: 0px;
}

.sidebar{
  display: block;
  position: fixed;
  background: white;
  height: 100%;
  width: 73px;
  margin-top: 68px;
  z-index: 2;
  box-shadow: 0px 4px 7px rgba(0, 0, 0, 0.25);
}

.sidebar ul{
  list-style-type:none;
}

.sidebar ul li{
  padding-top: 30px;
  padding-bottom: 30px;
  margin-left: -40px;

}

.icon-sidebar{
  width: 40px;
  height: 40px;
  cursor: pointer;
}

.icon-sidebar:hover{
    filter: invert(45%) sepia(3%) saturate(34%) hue-rotate(41deg) brightness(93%) contrast(88%);
}

.add-Menu{
  background-color: #57CAD5; 
  color: white;
}

@media screen and (max-width: 700px) {
        .sidebar{
            display: none;
        }
    }
</style>
