<template>
    <div>
        <div class="card">  
         <b-card overlay @click="storeToCart" class="card-photo"  img-alt="Image" img-top style="max-width: 20rem; justify-content: space-around;">
            <b-card-img class="card-img" :src="item.image" alt="Image" bottom></b-card-img>
            <div v-if="isHidden" class="card-img-overlay overlay d-flex ">
                <div class="my-auto mx-auto text-center">
                        <a href=""><i class="far fa-check-circle"></i></a>
                </div>
            </div>
        </b-card>
        <div class="body-card">
            <b-card-title v-model="category"  class="title">{{ item.name }} <span class="float-right" :style="[item['category.nama'] == 'drink' ? { backgroundColor: '#5bc0de' } : item['category.nama'] == 'cake' ? { backgroundColor: '#f0ad4e' } : item['category.nama'] == 'food' ? { backgroundColor: '#5cb85c' } : null]">{{ item['category.nama'] }}</span></b-card-title>
            <b-card-text class="price">Rp. {{ item.price }}  <span class="float-right"><span @click="showModal"><i class="fas fa-edit"></i></span><span @click="deleteMenu"><i class="fas fa-trash"></i></span></span></b-card-text>
        </div>
        </div>
    <div>
        <b-modal ref="edit-modal" hide-footer title="Edit Menu">
        <div class="d-block text-center">
          <div>
            <b-form-input style="margin-bottom: 25px;" v-model="edit_name"  placeholder="Enter food name"></b-form-input>
          </div>
          <div>
            <b-form-input style="margin-bottom: 25px;" v-model="edit_price"  placeholder="Enter food price"></b-form-input>
          </div>
          <div>
            <b-form-input style="margin-bottom: 25px;" v-model="edit_image"  placeholder="Enter food images"></b-form-input>
          </div>
          <div style="margin-bottom: 20px;">
            <b-form-select v-model="category" :options="options"></b-form-select>
          </div>
        </div>
        <b-button class="mt-2" style="border: none; background-color: #57CAD5; color: white; " block @click="editMenu">edit Menu </b-button>
        <b-button class="mt-3" style="border: none; background-color: #F24F8A; color: white; "  block @click="hideModal">Cancel</b-button>
    </b-modal>
    </div>
    </div>
</template>

<script>
    import axios from "axios"

    export default {
        name : "menu_card",
        props: [ "item", "removeData", "removeAllCheck" ], 

        data: function(){
            return{
                color : '',
                isHidden : false,
                id : this.item.id,
                edit_name: this.item.name,
                edit_price: this.item.price,
                edit_image: this.item.image,
                category : this.item.['category.nama'],
                options: [
                    { value: 'drink', text: 'drink' },
                    { value: 'cake', text: 'cake' },
                    { value: 'food', text: 'food' },
                    ],
                params : {
                    id : '',
                    name : '',
                    price: '',
                    category: '',
                    image: '',
                    num : 1,
                    total:0
                },
                params_store : {
                    id : '',
                    name : '',
                    price: '',
                    image: '',
                    num : 1
                },
                params_delete : {
                    id : 12,
                    name : 'fitra'
                },
            }
        },
        watch: { 
            removeData: function(newVal) { 
                this.id == newVal ? this.isHidden = false : null
            },
            removeAllCheck : function(newVal){
                if(newVal == true) this.isHidden = false
            }
        },
        methods: {
            showModal() {
                this.$refs['edit-modal'].show()
                
            },
            hideModal() {
                this.$refs['edit-modal'].hide()
            },
            editMenu() {
                this.putMenu(this.id, this.edit_name, this.edit_price, this.edit_image, this.category)
                this.$refs['edit-modal'].hide()
            },
            async putMenu(id, name, price, img, category_menu){
                parseInt(id)
                parseInt(price)
                this.params.id = id
                this.params.name = name
                this.params.price = price
                this.params.category = category_menu
                this.params.image = img
                this.params.total = price*this.params.num
                await axios.put(process.env.VUE_APP_URL, this.params)
                .then((res) => {
                        console.log(res.data)
                        this.load()
                    })
            },
            async deleteMenu(){
                //await axios.delete(process.env.VUE_APP_URL, { data: { name: this.edit_name } })
                const url = process.env.VUE_APP_URL
                const url2 = `?name=${ this.edit_name }`
                console.log(url.concat(url2))
                await axios.delete(url.concat(url2))
                 .then((res) => {
                         console.log(res.data)
                         this.load()
                     })
                 .catch((err) => { console.log(err)})
            },
            storeToCart(){
                this.isHidden = true
                this.params_store.id = this.id
                this.params_store.name = this.edit_name
                this.params_store.price = this.edit_price
                this.params_store.image = this.edit_image
                this.$emit("store_item", this.params_store);
            },
            load(){
                this.$router.go(this.$router.currentRoute)
            },    
        }
    }
    
</script>

<style scoped>
   .fa-check-circle{
    font-size: 70px;
    color: white; 
    }

    .overlay{
        background: rgba(0, 0, 0, 0.5);
        
    }
    span{
        color: white;
        font-size: 15px;
        padding: 5px;
        padding-right: 10px;
        padding-Left: 10px;
        border-radius: 15px;
    }
    .body-card{
        margin:10px;
        line-height: 10px;;
        margin-bottom: 20px;
    }

    .card-photo{
        width: 252px;
        height: 200px;
    }
    .card-img{
        margin-top: -20px;
        margin-left: -20px;
        width: 250px;
        height: 200px;
    }
    .price{
        font-size: 20px;
        text-align: left;
    }
    .fa-edit{
        color: rgba(190, 195, 202, 1);
        cursor: pointer;
        font-size: 20px;
        margin-right: -10px;
    }

    .fa-edit:hover{
        color: #5cb85c;
    }
    .fa-trash{
        color: rgba(190, 195, 202, 1);
        cursor: pointer;
        font-size: 20px;
    }

    .fa-trash:hover{
        color: #d9534f;
    }
    .title{
        text-align: left;
    }
    
</style>