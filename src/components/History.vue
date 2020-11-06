<template>
    <div class="row">
        <Navbar class="col-fluid row navbar"></Navbar>
        <div class="col-fluid content">
            <div class="dflex flex-row flex-wrap  card">
                <b-card class="card-item border-0 card-order" style="max-width: 25rem;">
                    <b-card-title style="font-size: 20px;  font-weight: 600;">Orders</b-card-title>
                    <b-card-title style="font-size: 30px; font-weight: 600;" class="value">{{ order }}</b-card-title>
                    <b-card-text>+5% Last Week</b-card-text>
                </b-card>
                <b-card class="card-item card-daily" style="max-width: 25rem;">
                    <b-card-title style="font-size: 20px; font-weight: 600;">Today's Income</b-card-title>
                    <b-card-title style="font-size: 30px; font-weight: 600;" class="value">Rp. {{ today_income }}</b-card-title>
                    <b-card-text>+2% Yesterday</b-card-text>
                </b-card>
                <b-card class="card-item card-month" style="max-width: 25rem;">
                   <b-card-title style="font-size: 20px; font-weight: 600;">This Month's Income</b-card-title>
                    <b-card-title style="font-size: 30px; font-weight: 600;" class="value">Rp. {{ month_income }}</b-card-title>
                    <b-card-text>+20% Last Month</b-card-text>
                </b-card>
                <b-card class="card-item card-year" style="max-width: 25rem;">
                    <b-card-title style="font-size: 20px; font-weight: 600;">This Year's Income</b-card-title>
                    <b-card-title style="font-size: 30px; font-weight: 500;" class="value">Rp. {{ year_income }}</b-card-title>
                    <b-card-text>+10% Last Year</b-card-text>
                </b-card>
            </div>
            <div class="col-fluid row  justify-content-center chart">
                <form>
                    <div class="form-group row header-cart">
                        <label style="text-align: left; font-size: 30px; font-weight: 700;"  class=" col-md-10 col-form-label col-form-label-sm" >Revenue</label>
                        <div class="align-items-center col-md-2">
                            <b-form-select v-model="selected" :options="options" size="sm" class="mt-2"></b-form-select>
                        </div>
                    </div>
                    <div class="form-group row c">
                         <line-chart :colors="['#d9534f', '#5cb85c']" width="1200px" height="500px" class="linechart" :data="data"  ></line-chart>
                    </div>
                </form>
            </div>

            <div class="col-fluidn row  justify-content-center table_section">
                <form>
                    <div class="form-group row header-cart">
                        <label style="text-align: left; font-size: 30px; font-weight: 700;"  class=" col-md-10 col-form-label col-form-label-sm" >Recent Order</label>
                        <div class="align-items-center col-md-2">
                            <b-form-select v-model="selected" :options="options" size="sm" class="mt-2"></b-form-select>
                        </div>
                    </div>
                    <div class="form-group row ">
                         <b-table class="table-bordered" hover :items="data_history" :fields="fields" caption-top>
                    </b-table>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>

<script>
    import axios from 'axios'
    import Navbar from './component_history/navbar'
    export default {
        name: 'History',
        components: {
            Navbar
        },
        data: function(){
            return{
                order : 0,
                today_income : 0,
                month_income : 2300000,
                year_income : 12000000,
                data : [
                    {name: 'This Week', data: {'sunday': 1200000, 'monday': 500000, 'tuesday': 900000, 'wednesday': 1050000}},
                    {name: 'Last Week', data: {'sunday': 630000, 'monday': 2000000, 'tuesday': 1100000, 'wednesday': 890000, 'thursday': 1600000, 'friday': 1050000, 'saturday': 1050000}}
                ],
                selected: 'week',
                options: [
                { value: 'month', text: 'Month' },
                { value: 'week', text: 'Week' },
                { value: 'year', text: 'Year' },
                ],
                fields: ['invoice', 'cashier', 'orders', 'total'],
                data_history: null
            }
        },
        watch: {
           
        },
        computed:{
            
        },
        created(){
             if (localStorage.getItem("token") === null){
                this.$router.push('/')
            } else {
                const token = localStorage.getItem('token')
                const refreshToken = localStorage.getItem('refreshToken')
                const config = { headers: { Authorization: `Bearer ${token}` } }
                axios.get(process.env.VUE_APP_HISTORY, config)
                    .then((res) => {
                        this.data_history = res.data.result
                        console.log(this.data_history)
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
    .navbar{
        width: 101.6%;
        height: 67px;
        box-shadow: 0px 3px 8px rgba(0, 0, 0, 0.25);
        position: fixed;
        background: white;
        z-index: 10;
    }
    .content{
        height: 100vh;
        margin-top: 70px;
        margin-left: 90px;
        width: 100%;
    }
    .card{
        width: 100%;
        justify-content: space-around;
        margin-bottom: 30px;
        padding-top: 30px;
        z-index: 0;
        border: none;
    }
    .card .card-item{
        padding-top: 0px;
        height: 230px;
        border-radius: 10px;
        text-align: left;
        line-height: 30px;
        font-weight: 600;
        padding-top: 35px;
        padding-left: 20px;
        border: none;
    }

    .value{
        line-height: 20px;
    }
    .card-order{
        background: linear-gradient(278.29deg, #FBB2B4 30.05%, rgba(255, 143, 178, 0) 133.19%);
        filter: drop-shadow(10px 15px 10px rgba(255, 143, 178, 0.25))
    }
    .card-daily{
        background: linear-gradient(278.29deg, #29DFFF 30.05%, rgba(41, 223, 255, 0) 133.19%);
        filter: drop-shadow(10px 15px 10px rgba(41, 223, 255, 0.25));
    }
    .card-month{
        background-color: #FBAB7E;
        background-image: linear-gradient(225deg, #FBAB7E 0%, #ffe5b4 100%);
        filter: drop-shadow(10px 15px 10px rgba(251, 171, 126, 0.25));
    }
    .card-year{
       background-color: #85FFBD;
       background-image: linear-gradient(225deg, #85FFBD 0%, #7dff8c 100%);
       filter: drop-shadow(10px 15px 10px rgba(125, 255, 140, 0.25));
    }
    .chart{
        margin: 30px;
        width: 100%;
        margin-top: 100px;
    }

    .chart form div{

        width: 1200px;
    }

    .chart .chart-title {
        margin-bottom: 30px;
    }

    .table_section{
        margin: 30px;
        margin-top: 100px;
    }
    .table{
        width: 1200px;
        align-items: center;
    }

    @media screen and (max-width: 1000px) {
       .card-item{
           width: 60vh;
       }
       .chart{
           display: none;
       }
    }

    @media screen and (max-width: 700px) {
        .content{
        margin-left: 10px;
        width: 100%;
        }
        .table_section{
            display: none;
        }
    }

</style>