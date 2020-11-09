<template>
    <div class="container">
        <div id="login" v-if="login_status" >
           <div id="inputContainer">
               <form>
                    <h3 style="margin-bottom: 30px;">Sign Up</h3>
                    <b-form-group class="register_email">
                       <input v-model="login_email" type="email" id="inputFieldEmail" ref="registerinputEmail" required>
                      <label id="inputLabel"> Email </label>
                   </b-form-group>
                    <b-form-group class="register_password">
                       <input v-model="login_password" type="password" id="inputFieldPassword" ref="registerinputEmail" required>
                      <label id="inputLabel"> Password </label>
                   </b-form-group>
                   <p>forgot your <span style="font-weight: 600; cursor: pointer;"> password</span> ?</p>
                    <b-button class="button-login" @click="login" style="background: #57CAD5;">SIGN IN</b-button>
               </form>
               
           </div>
       </div>
       <div id="login-button" v-if="!login_status" style="background:  #57CAD5; padding-top: 80px; transition: .5s ease-in-out;">
           <div id="inputContainer">
               <form>
                    <h3 style="margin-bottom: 30px; color: white; font-weight: 600;">Cashier App!</h3>
                    <p style="color: white; font-size: 18px; font-weight: 600; margin-top: -20px;">You have an account?</p>
                     <b-button class="button-login" @click="switch_login" style="border: 2px solid white; background:  #57CAD5;  margin-top: 0px;" >SIGN IN</b-button>
               </form>
               
           </div>
       </div>
         <div id="register-button" v-if="login_status" style="background: #F24F8A; padding-top: 80px; transition: .5s ease-in-out;">
           <div id="inputContainer">
               <form>
                    <h3 style="margin-bottom: 30px; color: white; font-weight: 600;">Cashier App!</h3>
                    <p style="color: white; font-size: 18px; font-weight: 600; margin-top: -20px;">Don't you have an account?</p>
                     <b-button class="button-register" @click="switch_register" style="border: 2px solid white;  margin-top: 0px; background:#F24F8A;">SIGN UP</b-button>
               </form>
               
           </div>
       </div>
       <div id="register" v-if="!login_status">
           <div id="inputContainer">
               <form>
                    <h3 style="margin-bottom: 30px;">Sign Up</h3>
                   <b-form-group>
                       <input type="text" v-model="username_register" id="inputField" ref="registerinput" required>
                      <label id="inputLabel"> Username </label>
                   </b-form-group>
                    <b-form-group class="register_email">
                       <input type="email" v-model="email_register" id="inputFieldEmail" ref="registerinputEmail" required>
                      <label id="inputLabel"> Email </label>
                   </b-form-group>
                    <b-form-group class="register_password">
                       <input type="password" v-model="password_register" id="inputFieldPassword" ref="registerinputEmail" required>
                      <label id="inputLabel"> Password </label>
                   </b-form-group>
                    <b-button class="button-register" @click="register" style="background:#F24F8A;">SIGN UP</b-button>
               </form>
               
           </div>
       </div>
    </div>
</template>

<script>
   import axios from 'axios'

    export default {
        data: () => {
            return{
                login_status: true,
                login_email: '',
                login_password: '',
                email_register: '',
                password_register: '',
                username_register: '',
            }
            
        },
        methods: {
           switch_login(){
               this.login_status= true
           },
           switch_register(){
               this.login_status= false
           },
           reset_login(){
                this.login_email = '',
                this.login_password = ''
           },
           reset_register(){
                this.email_register = '',
                this.password_register = '',
                this.username_register = ''
           }, 
           async login(){
               let params =  {
                   email  : this.login_email,
                   password : this.login_password
               }
               this.reset_login()
               await axios.post(process.env.VUE_APP_AUTH, params)
                .then((res) => {
                        console.log(res.data)
                        localStorage.setItem('token', res.data.accessToken)
                        localStorage.setItem('refreshToken', res.data.refreshToken)
                        this.$router.push('/menu')
                    })
                .catch((err) => {
                    console.log(err)
                })
           },
           async register(){
                let params =  {
                   username: this.username_register,
                   email  : this.email_register,
                   password : this.password_register
               }
               await axios.post(process.env.VUE_APP_REGISTER, params)
                .then(() => {
                        console.log("berhasil daftar")
                    })
                .catch((err) => {
                    console.log(err)
                })
                this.reset_register()
           }
        }
        ,
        mounted() {

            }
        }
</script>

<style scoped>
    .container{
        position: relative;
        font-family: 'Noto Sans', sans-serif;
        font-size: 1rem;
        color: #333;
        width: 100%;
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        
    }

    #register, #login, #register-button, #login-button{
        position: relative;
        width: 370px;
        height: 440px;
        padding: 10px;
        background-color: #fff;
        z-index: 1;
        box-shadow: 10px 0px 30px 0px rgba(0,0,0,.1),
                    0px 0px 20px 0px rgba(0,0,0,.1);
    }

    #register, #register-button{
         border-top-right-radius: 8px;
         border-bottom-right-radius: 8px;
    }

    #login, #login-button{
         border-top-left-radius: 8px;
         border-bottom-left-radius: 8px;
    }
    
    #inputContainer {
        position: relative;
        padding: 50px 0px 20px 40px;
        margin-right: 60px;

    } 
    #inputContainer input {
        position: relative;
        width: 100%;
        font-size: 1rem;
        font-weight: 500;
        outline: 0;
        background: transparent;
        box-shadow: none;
        border-top: none;
        border-right: none;
        border-left: none;

        margin-top: 15px;
        padding: 5px;

    }

     #inputContainer input:focus + #inputLabel {
        padding-top: 0px;
        padding-left: 0px;
        font-size: .7rem;
        font-weight: normal;
        color: #999;
    }

    #inputContainer input:focus  {
        padding-top: 13px;
        transition: .2s ease-in-out;
        
    }
    
    #inputContainer input:valid  {
        padding-top: 13px;
        transition: .2s ease-in-out; 
    }

    #inputLabel {
        position: absolute;
        margin-top: 15px;
        left: 40px;
        font-size: 1rem;
        font-weight: 600;
        pointer-events: none;
        transition: .2s ease-in-out;
    }
   
    .button-login{
        border-radius: 18px;
        width: 100px;
        font-size: 15px;
        font-weight: 600;
        margin-top: 60px;
    }

    .button-register{
        border-radius: 18px;
        width: 100px;
        font-size: 15px;
        font-weight: 600;
        margin-top: 32px;
        
    }
  
   
</style>