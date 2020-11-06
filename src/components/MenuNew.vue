<template>
    <div class="container-fluid">
        <div class="row">
            <div class="col-fluid section">
                <nav class="col-fluid nav">
                    <Navbar v-on:dataSearch="searchMethod" class="navbar"></Navbar>
                </nav>
                <section class="col-fluid">
                    <div class=" row justify-content-end sort-space">
                        <div class="sort float-right">
                            <Sort v-on:child-select="selectMethod" />
                        </div>
                    </div>
                    <div class="col-fluid content d-flex align-content-start flex-wrap ">
                            <div v-for="item in data" :key="item.id">
                                <Card v-on:store_item="storeMethod" class="item" :item = "item" :removeData="removeData" :removeAllCheck="removeAllCheck" ></Card>
                            </div>     
                    </div>
                </section>
            </div>
            <aside class="col-fluid aside">
                <div class="col-fluid cart-header">
                    <h3 class="cart-title">Cart <span class="quantity-total">{{ cart_count_item }}</span></h3>
                </div>
                <div class="col-fluid cart-body">
                    <div v-if="cart_count_item == 0" class="cart-not-found">
                        <img src="https://i.ibb.co/MRkSPDJ/food-and-restaurant.png" alt="">
                        <h3>Your cart is empty</h3>
                        <p>Please add some items from the menu</p>
                    </div>
                    <div class="cart-item">
                        <div v-for="item in cart" :key="item.id" class="col-fluid">
                            <itemInCart v-on:delete_id="idDelete" v-on:item_num="num_item" :item = "item" class="item-cart"></itemInCart>
                        </div>
                        <div class="checkout" v-if="cart_count_item > 0" >
                            <h4>Total : <span class="float-right">Rp. {{ total_price }}*</span></h4>
                            <h5>* Belum termasuk ppn</h5>
                            <b-button  size="lg" class="mt-2" @click="generateNum" style="border: none; background-color: #57CAD5; color: white; " block >add Receipt </b-button>
                            <b-button @click="cancelCart" size="lg" class="mt-3" style="border: none; background-color: #F24F8A; color: white; "  block >Cancel</b-button>
                        </div>
                    </div>
                </div>
            </aside>
        </div>
        <b-modal ref="modal-checkout" hide-header  hide-footer title="Edit Menu">
           <div class="modal-checkout-header" >
                 <p class="my-4" style="font-size: 25px;">Checkout  <span class="float-right" style="font-size: 18px;">Receipt no: {{ invoces_recipes }}</span></p>
                 <p style="font-size: 16px;">Cashier : {{ name_cashier }}</p>
             </div>
             <div style="margin-top: 30px;">
                <div v-for="item in cart" :key="item.id">
                <listReceipt :item="item" style="margin-top: 7px;" ></listReceipt>
                </div>
                <div style="font-size: 18px; margin-top: 7px;"><span>PPN 10%</span> <span class="float-right"> Rp. {{ ppn_tax }}</span></div>
             </div>
             <div style="margin-top: 50px; ">
                <div style="font-size: 21px;"><span class="float-right">Total : <span style="margin-left: 30px;">Rp. {{ total_all }}</span></span></div>
             </div>
             <div style="padding-top: 50px;">
                 <b-button size="lg" class="mt-2" style="border: none; background-color: #57CAD5; color: white; " block @click="checkout">Checkout </b-button>
                 <b-button size="lg" class="mt-3" style="border: none; background-color: #F24F8A; color: white; "  block @click="hideModal">Cancel</b-button>
             </div>
    </b-modal>
    </div>
</template>

<script>
    import axios from 'axios'

    import Navbar from './component_Menu/navbar.vue'
    import Sort from './component_Menu/sort.vue'
    import Card from './component_Menu/menu_card'
    import itemInCart from './component_Menu/item_in_cart'
    import listReceipt from './component_Menu/list_receipt'


    export default {
        name : "Menu",
        components : {
            Navbar,
            Sort,
            Card,
            itemInCart,
            listReceipt,
        },
        data: function(){
            return{
                data: null,
                quantityItem : 0,
                cart : [], 
                removeData : 0,
                dataSearch : null,
                url : process.env.PRODUCT_API_KEY,
                cart_checkout : [],
                invoces_recipes : 0,
                ppn_tax : 1,
                refresh_token: '',
                total_all : 1,
                name_cashier: "Pevita Pearce",
                params : {
                    invoices: '',
                    cashier: '',
                    orders: '',
                    total: ''
                }
            }
        },
        methods: {
            storeMethod(value){
                if(this.cart.length == 0){
                    this.cart.push(value)
                }else{
                    let name = []
                    this.cart.forEach(element => {
                         name.push(element.name)
                     })
                    name.includes(value.name) == false ?  this.cart.push(value) : null
                }
            },
            selectMethod(value){
                if(value == 'name'){
                    axios.get(process.env.VUE_APP_PRODUCT_ORDERBYNAME)
                        .then((res) => {this.data = res.data.result })
                        .catch((err) => { console.log(err)})
                }else if (value == 'priceL'){
                    axios.get(process.env.VUE_APP_PRODUCT_ORDERBYPRICEL)
                        .then((res) => {this.data = res.data.result  })
                        .catch((err) => { console.log(err)})
                }else if (value == 'category'){
                    axios.get(process.env.VUE_APP_PRODUCT_ORDERBYCATEGORY)
                        .then((res) => {this.data = res.data.result  })
                        .catch((err) => { console.log(err)})
                }else if (value == 'Newer'){
                    axios.get(process.env.VUE_APP_PRODUCT_ORDERBYNEW)
                        .then((res) => {this.data = res.data.result  })
                        .catch((err) => { console.log(err)})
                }else if (value == null){
                    axios.get(process.env.VUE_APP_URL)
                        .then((res) => {this.data = res.data.result  })
                        .catch((err) => { console.log(err)})
                }
            },
            searchMethod(value){
                console.log(process.env.VUE_APP_SEARCH)
                axios.get(process.env.VUE_APP_SEARCH, { params: { name: value } })
                        .then((res) => {this.data = res.data.result })
                        .catch((err) => { console.log(err)})

            },
            idDelete(value){
                let id = []
                this.cart.forEach(element => {
                    id.push(element.id)
                })
                let loc = id.indexOf(value)
                this.cart = this.cart.slice(0, loc).concat(this.cart.slice(loc + 1, this.cart.length))
                return this.removeData = value
                
            },
            num_item(value){
                let dataId = value.id
                let numData = value.num
                this.cart.forEach(element => {
                    if(element.id == dataId){
                        element.num = numData
                    }
                })
            },
            cancelCart(){
                this.cart = []
            },
            generateNum(){
                this.invoces_recipes = '#'+Math.floor(Math.random()*100000)
                let total = this.cart.map(item => parseInt(item.price)*item.num).reduce((prev, next) => prev + next)
                this.ppn_tax =  total*0.1
                this.total_all = total+this.ppn_tax
                this.showModal()
            },
            checkout(){
                const menu_arr = this.cart.map(item => item.name)
                const menu = menu_arr.join(", ")
                this.postCheckout(this.invoces_recipes, this.name_cashier, menu, this.total_all )
            },
             showModal() {
                this.$refs['modal-checkout'].show()
            },
            hideModal() {
                this.$refs['modal-checkout'].hide()
            },
            async postCheckout(invoices, cashier, menu_list, total){
                this.params.invoices = invoices
                this.params.cashier = cashier
                this.params.orders = menu_list
                this.params.total = total
                await axios.post(process.env.VUE_APP_HISTORY, this.params)
                .then(() => {
                        
                        this.hideModal()
                        this.load()
                    })
                .catch(((err) => {
                        console.log(err)
                    }))
            },
            load(){
                this.$router.go(this.$router.currentRoute)
            }, 
        },
        computed: {
            cart_count_item: function(){
                return this.cart.length 
            },
            total_price: function(){
               return this.cart.map(item => parseInt(item.price)*item.num).reduce((prev, next) => prev + next)
            },
            removeAllCheck: function(){
                if(this.cart.length == 0){
                    return true
                }else{
                    return false
                }
            },
            
        },
        watch : {
            
        },
        mounted() { 
            if (localStorage.getItem("token") === null){
                this.$router.push('/')
            } else {
                const token = localStorage.getItem('token')
                const refreshToken = localStorage.getItem('refreshToken')
                const config = { headers: { Authorization: `Bearer ${token}` } }
                axios.get(process.env.VUE_APP_URL, config)
                    .then((res) => {
                        this.data = res.data.result
                        console.log(this.data)
                    })
                    .catch((err) => {
                        //console.log(err.response.status)
                        if(err.response.status === 401){
                            const params = { refreshToken: `${refreshToken}` }
                            axios.post(process.env.VUE_APP_REFRESHTOKEN, params)
                                .then((res) => {
                                    localStorage.setItem('token', res.data.accessToken)
                                    console.log('ganti token')
                                    this.$router.go(this.$router.currentRoute)
                                })
                                .catch((error) => {
                                    if(error.response.status === 401){
                                         this.$router.push('/')
                                    }
                                })
                        }
                    })
            }
        }
    }
</script>

<style scoped>
    .row{
        height: 100vh;
        width: 100%;
        margin-left: 0px;
    }
    .section{
        background: rgba(190, 195, 202, 0.3);
        
        width: 72%;
       
    }
    aside{
        width: 28%;
        margin-left: 0;
    }
    nav{
        width: 100%;
        height: 68px;
    }
    section{
        width: 100%;
      
        
    }
    .navbar{
        box-shadow: 0px 3px 2px rgba(0, 0, 0, 0.25);
        height: 70px;
        margin-left: -20px;
        position: fixed;
        width: 1323px;
        margin-top: -5px;
        background: white;
        z-index: 5;
       
    }
    .sort-space{
        width: 100%;
        height: 60px;
    }
    .sort{
        width: 300px;
        padding-top: 30px;
        padding-right: 30px;
    }
    .content{
        margin-top: 0px;
        margin-left: 90px;
        
    }
    .item{
        margin : 20px;
        z-index: 1;
    }
    aside{
        width: 28%;
    }
    .cart-header{
        display: block;
        width: 100%;
        height: 65px;
        background: white;
        position: fixed;
        box-shadow: 0px 3px 2px rgba(0, 0, 0, 0.25);
        color: black;   
        z-index: 4;
    }

    .cart-title{
        line-height: 60px;
        position: fixed;
        margin-left: 12%;
    }
    .cart-title h3{
        text-align: center;
    }
   
    .cart-body{
        width: 100%;
        height: 100vh;
    }
    .quantity-total{
        background: #5bc0de;
        padding-right: 5px;
        padding-left: 5px;
        border-radius: 15px;
    }
    .item-cart{
        height: 150px;
        margin-bottom: 20px;
    }

    .cart-not-found{
        position: fixed;
        margin-left: 7%;
        line-height: 20px;
    }
    .cart-item{
        margin-top: 100px;
    }
    .checkout{
        margin: 30px;
        margin-top: 50px;
        text-align: left;
    }
    .checkout h4{
        text-align: left;
    }
    .checkout b-button{
        height: 100px;
    }
    .modal-checkout-header{
        line-height: 5px;
    }

@media screen and (max-width: 1700px) {
        .aside{
            display: none;
        }
        .section{
            width: 100%;
            margin: 0;
            padding: 0;
        }
        .navbar{
            width: 100%;
        }
        .content{
            margin-left: 120px;
        }
        
    }
@media screen and (max-width: 1800px) {
        .content{
            margin-left: 50px;
        }
        
    }
@media screen and (max-width: 1050px) {
        .content{
            margin-left: 80px;
        }
        
    }
@media screen and (max-width: 700px) {
        .content{
            margin-left: 15%;
        }
        
    }
    
    

   
</style>