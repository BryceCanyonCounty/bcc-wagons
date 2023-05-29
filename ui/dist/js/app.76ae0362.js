(function(){"use strict";var e={7249:function(e,t,n){var o=n(9242),s=n(3396);const a={key:0,id:"content"};function i(e,t,n,o,i,l){const c=(0,s.up)("router-view");return i.visible||i.devmode?((0,s.wg)(),(0,s.iD)("div",a,[(0,s.Wm)(c)])):(0,s.kq)("",!0)}var l={name:"DefaultLayout",data(){return{devmode:!1,visible:!1}},mounted(){window.addEventListener("message",this.onMessage)},unmounted(){window.removeEventListener("message",this.onMessage)},methods:{onMessage(e){switch(e.data.action){case"show":this.visible=!0,this.$store.dispatch("setWagons",e.data.shopData),this.$store.dispatch("setShopName",e.data.location),this.$store.dispatch("setCurrencyType",e.data.currencyType);break;case"updateMyWagons":this.$store.dispatch("setMyWagons",e.data.myWagonsData);break;case"hide":this.visible=!1,this.$store.dispatch("setMyWagons",null),this.$store.dispatch("setWagons",null),this.$store.dispatch("setShopName",null),this.$store.dispatch("setCurrencyType",2);break;default:break}}}},c=n(89);const r=(0,c.Z)(l,[["render",i]]);var d=r,u=n(2483),m=n(7139);const p=e=>((0,s.dD)("data-v-478943f9"),e=e(),(0,s.Cn)(),e),g={class:"container"},h={class:"main"},v={class:"header"},f={class:"header-text"},y={class:"btn-menu main-nav-buttons"},b=p((()=>(0,s._)("div",{class:"divider-menu-top"},null,-1))),w={key:0,class:"scroll-container"},_={key:1,class:"scroll-container"},M=p((()=>(0,s._)("div",{class:"divider-menu-top",style:{"margin-top":"1rem"}},null,-1))),W={class:"btn-bottom-main btn-bottom"},x=p((()=>(0,s._)("i",{class:"fas fa-chevron-left center"},null,-1))),C=[x],k=p((()=>(0,s._)("div",{class:"rotate-text"},[(0,s._)("span",{class:"grey-text center"},"Rotate")],-1))),S=p((()=>(0,s._)("i",{class:"fas fa-chevron-right center"},null,-1))),T=[S],E=p((()=>(0,s._)("div",{class:"divider-menu-bottom"},null,-1)));function D(e,t,n,o,a,i){const l=(0,s.up)("MenuButton"),c=(0,s.up)("MyWagonMenu"),r=(0,s.up)("ShopMenu");return(0,s.wg)(),(0,s.iD)("div",g,[(0,s._)("div",h,[(0,s._)("div",v,[(0,s._)("div",f,(0,m.zw)(e.shopName),1)]),(0,s._)("div",y,[(0,s.Wm)(l,{label:"My Wagons",selectedPage:a.page,onClick:t[0]||(t[0]=e=>a.page="wagons"),class:"enabled"},null,8,["selectedPage"]),(0,s.Wm)(l,{label:"Wagon Shop",selectedPage:a.page,onClick:t[1]||(t[1]=e=>a.page="shop"),class:"enabled"},null,8,["selectedPage"])]),b,"wagons"==a.page?((0,s.wg)(),(0,s.iD)("div",w,[(0,s.Wm)(c)])):"shop"==a.page?((0,s.wg)(),(0,s.iD)("div",_,[(0,s.Wm)(r)])):(0,s.kq)("",!0),M,(0,s._)("div",W,[(0,s._)("button",{id:"cancel",class:"btn-select",onClick:t[2]||(t[2]=e=>i.close())},"Save"),(0,s._)("button",{id:"rotate_left",class:"btn-select btn-rotate",onMousedown:t[3]||(t[3]=e=>i.startRotate("left")),onMouseleave:t[4]||(t[4]=(...e)=>i.onMouseLeave&&i.onMouseLeave(...e))},C,32),k,(0,s._)("button",{id:"rotate_right",class:"btn-select btn-rotate",onMousedown:t[5]||(t[5]=e=>i.startRotate("right")),onMouseleave:t[6]||(t[6]=(...e)=>i.onMouseLeave&&i.onMouseLeave(...e))},T,32),(0,s._)("button",{id:"cancel",class:"btn-select",onClick:t[7]||(t[7]=e=>i.close())},"Close")]),E])])}var O=n(65),I=n(6265),N=n.n(I);const R=N().create({baseURL:`https://${"undefined"!==typeof GetParentResourceName?GetParentResourceName():"bcc-wagons"}/`});var A=R;function P(e,t,n,o,a,i){return(0,s.wg)(),(0,s.iD)("button",{class:(0,m.C_)({active:i.isActive})},(0,m.zw)(n.label),3)}var j={name:"MenuButton",props:{label:String,selectedPage:String},computed:{isActive(){return this.label==this.selectedPage}}};const $=(0,c.Z)(j,[["render",P],["__scopeId","data-v-33c26727"]]);var L=$;const G=e=>((0,s.dD)("data-v-38987f18"),e=e(),(0,s.Cn)(),e),Y={key:0},q={key:0},H={key:1},Z=(0,s.uE)('<div class="text" data-v-38987f18><div class="container" data-v-38987f18><div class="flex panel" data-v-38987f18><div class="flex flex-auto panel-title" data-v-38987f18><h6 class="grey-text plus" data-v-38987f18> No Wagons!  Head to the Shop </h6></div></div></div></div>',1),z=[Z],U={key:1},B=G((()=>(0,s._)("img",{src:"img/6cyl_revolver.png",alt:"",class:"image"},null,-1))),V=[B];function K(e,t,n,o,a,i){const l=(0,s.up)("MyWagonMenuItem");return e.myWagons?((0,s.wg)(),(0,s.iD)("div",Y,[Object.keys(e.myWagons).length?((0,s.wg)(),(0,s.iD)("div",q,[(0,s._)("div",null,[((0,s.wg)(!0),(0,s.iD)(s.HY,null,(0,s.Ko)(e.myWagons,((e,n)=>((0,s.wg)(),(0,s.j4)(l,{label:e.name,index:e.id,model:e.model,wagon:e,selected:a.activeDropdown,key:n,onIExpanded:t[0]||(t[0]=e=>i.onChildExpansion(e))},null,8,["label","index","model","wagon","selected"])))),128))])])):((0,s.wg)(),(0,s.iD)("div",H,z))])):((0,s.wg)(),(0,s.iD)("div",U,V))}const F=e=>((0,s.dD)("data-v-1a5c72b4"),e=e(),(0,s.Cn)(),e),J={class:"container"},Q={class:"panel"},X={class:"grey-text plus"},ee={key:0,class:"fas fa-chevron-left center active-horse mr"},te={key:1,class:"fas fa-chevron-right center active-horse ml"},ne={key:0,class:"mb"},oe=F((()=>(0,s._)("div",null,null,-1))),se={class:"panel-myhorse item"},ae=F((()=>(0,s._)("div",{class:""},null,-1))),ie=F((()=>(0,s._)("p",{style:{"text-align":"center"}},"Are you sure you want to sell?",-1))),le=F((()=>(0,s._)("div",{class:"divider-menu-top",style:{"margin-top":"1rem"}},null,-1))),ce={class:"flex cta-wrapper"},re=F((()=>(0,s._)("img",{src:"img/money.png"},null,-1))),de=F((()=>(0,s._)("div",{class:"divider-menu-bottom"},null,-1)));function ue(e,t,n,o,a,i){const l=(0,s.up)("ConfirmationModal");return(0,s.wg)(),(0,s.iD)(s.HY,null,[(0,s._)("div",J,[(0,s._)("div",Q,[(0,s._)("div",{class:"panel-title",onClick:t[0]||(t[0]=e=>[i.SelectWagon(),i.Expand()])},[(0,s._)("h6",X,[i.isActive?((0,s.wg)(),(0,s.iD)("i",ee)):(0,s.kq)("",!0),(0,s.Uk)(" "+(0,m.zw)(n.label)+" ",1),i.isActive?((0,s.wg)(),(0,s.iD)("i",te)):(0,s.kq)("",!0)])])]),i.isOpen?((0,s.wg)(),(0,s.iD)("div",ne,[oe,(0,s._)("div",se,[(0,s._)("button",{class:"item-myhorse",onClick:t[1]||(t[1]=e=>i.RenameWagon())},"Rename"),(0,s._)("button",{class:"item-myhorse",onClick:t[2]||(t[2]=e=>i.SpawnWagon())},"Spawn"),(0,s._)("button",{class:"item-myhorse",onClick:t[3]||(t[3]=(...e)=>i.toggleModal&&i.toggleModal(...e))},"Sell")]),ae])):(0,s.kq)("",!0)]),(0,s.Wm)(l,{visible:a.showModal,title:"Confirm",onClose:i.toggleModal},{default:(0,s.w5)((()=>[ie,le,(0,s._)("div",ce,[(0,s._)("button",{onClick:t[4]||(t[4]=(...e)=>i.SellWagon&&i.SellWagon(...e)),class:"modal-btn flex flex-auto"},[re,(0,s.Uk)("Sell ")]),(0,s._)("button",{onClick:t[5]||(t[5]=(...e)=>i.toggleModal&&i.toggleModal(...e)),class:"modal-btn flex flex-auto"}," Cancel ")]),de])),_:1},8,["visible","onClose"])],64)}const me={key:0,class:"modal-wrapper"},pe={class:"modal"},ge={class:"modal-header"},he={class:"modal-body"};function ve(e,t,n,o,a,i){return n.visible?((0,s.wg)(),(0,s.iD)("div",me,[(0,s._)("div",{class:"modal-overlay",onClick:t[0]||(t[0]=(...e)=>i.close&&i.close(...e))}),(0,s._)("div",pe,[(0,s._)("div",ge,[(0,s._)("span",null,(0,m.zw)(n.title),1)]),(0,s._)("div",he,[(0,s.WI)(e.$slots,"default",{},void 0,!0)])])])):(0,s.kq)("",!0)}var fe={name:"ConfirmationModal",props:{visible:{type:Boolean,required:!0},title:{type:String,default:"Modal Title"}},methods:{close(){this.$emit("update:visible",!1)}},computed:{isActive(){return this.label==this.selectedPage}}};const ye=(0,c.Z)(fe,[["render",ve],["__scopeId","data-v-4dfe12d2"]]);var be=ye,we={name:"MyWagonMenuItem",props:{label:String,index:Number,model:String,selected:Number,wagon:Object},data(){return{showModal:!1}},emits:["iExpanded"],computed:{...(0,O.rn)(["activeWagon"]),isOpen(){return this.index==this.selected},isActive(){return this.activeWagon&&this.index==this.activeWagon["id"]}},methods:{Expand(){this.isOpen||this.$emit("iExpanded",this.index)},SelectWagon(){this.isOpen||(this.$store.dispatch("setSelectedWagon",this.wagon),A.post("SelectWagon",{WagonId:this.index}).catch((e=>{console.log(e.message)})),A.post("LoadMyWagon",{WagonId:this.index,WagonModel:this.model}).catch((e=>{console.log(e.message)})))},RenameWagon(){A.post("RenameWagon",{WagonId:this.index}).catch((e=>{console.log(e.message)}))},SellWagon(){A.post("SellWagon",{WagonId:this.index,WagonModel:this.model,WagonName:this.label}).catch((e=>{console.log(e.message)}))},SpawnWagon(){A.post("SpawnInfo",{WagonId:this.index,WagonModel:this.model,WagonName:this.label}).catch((e=>{console.log(e.message)})),A.post("CloseMenu",{MenuAction:"Close"}).catch((e=>{console.log(e.message)}))},toggleModal(){this.showModal=!this.showModal}},components:{ConfirmationModal:be}};const _e=(0,c.Z)(we,[["render",ue],["__scopeId","data-v-1a5c72b4"]]);var Me=_e,We={name:"MyWagonMenu",data(){return{activeDropdown:-1}},methods:{onChildExpansion(e){this.activeDropdown=e}},components:{MyWagonMenuItem:Me},computed:(0,O.rn)(["myWagons"])};const xe=(0,c.Z)(We,[["render",K],["__scopeId","data-v-38987f18"]]);var Ce=xe;function ke(e,t,n,o,a,i){const l=(0,s.up)("ShopMenuItem");return(0,s.wg)(),(0,s.iD)("div",null,[((0,s.wg)(!0),(0,s.iD)(s.HY,null,(0,s.Ko)(e.wagons,((e,t)=>((0,s.wg)(),(0,s.j4)(l,{wagon:e,index:t,selected:a.activeDropdown,key:t,onIExpanded:e=>i.onChildExpansion(e,t)},null,8,["wagon","index","selected","onIExpanded"])))),128))])}const Se={class:"container"},Te={class:"flex flex-auto panel-title"},Ee={class:"grey-text plus"},De={key:0};function Oe(e,t,n,o,a,i){const l=(0,s.up)("ShopMenuItemType");return(0,s.wg)(),(0,s.iD)("div",Se,[(0,s._)("div",{class:"flex panel",onClick:t[0]||(t[0]=e=>i.Expand())},[(0,s._)("div",Te,[(0,s._)("h6",Ee,(0,m.zw)(n.wagon.name),1)])]),i.isOpen?((0,s.wg)(),(0,s.iD)("div",De,[((0,s.wg)(!0),(0,s.iD)(s.HY,null,(0,s.Ko)(n.wagon.types,((e,t)=>((0,s.wg)(),(0,s.iD)("div",{class:"item",key:t},[(0,s.Wm)(l,{wagon:e,model:t},null,8,["wagon","model"])])))),128))])):(0,s.kq)("",!0)])}const Ie=e=>((0,s.dD)("data-v-624b2163"),e=e(),(0,s.Cn)(),e),Ne={class:"item flex flex-auto"},Re={class:"grey-text-shop title"},Ae={class:"buy-buttons flex flex-auto justify-end"},Pe=Ie((()=>(0,s._)("img",{src:"img/money.png",class:"ml-1"},null,-1))),je={class:"ml-1"},$e=Ie((()=>(0,s._)("img",{src:"img/gold.png",class:"ml-1"},null,-1))),Le={class:"ml-1"},Ge=Ie((()=>(0,s._)("div",{class:"divider-menu-top",style:{"margin-top":"1rem"}},null,-1))),Ye={class:"flex cta-wrapper"},qe=Ie((()=>(0,s._)("div",{class:"divider-menu-bottom"},null,-1)));function He(e,t,n,o,a,i){const l=(0,s.up)("ConfirmationModal");return(0,s.wg)(),(0,s.iD)(s.HY,null,[(0,s._)("div",{class:"panel-shop item flex",onClick:t[2]||(t[2]=e=>i.loadWagon())},[(0,s._)("div",Ne,[(0,s._)("h6",Re,(0,m.zw)(n.wagon.label),1)]),(0,s._)("div",Ae,[i.useCash?((0,s.wg)(),(0,s.iD)("button",{key:0,style:{display:"flex","justify-content":"flex-start"},class:(0,m.C_)(["btn-small",{mr:!i.useGold}]),onClick:t[0]||(t[0]=e=>i.openConfirmationModal(!0))},[Pe,(0,s._)("span",je,(0,m.zw)(n.wagon.cashPrice),1)],2)):(0,s.kq)("",!0),i.useGold?((0,s.wg)(),(0,s.iD)("button",{key:1,style:{display:"flex","justify-content":"flex-start"},class:"btn-small right-btn",onClick:t[1]||(t[1]=e=>i.openConfirmationModal(!1))},[$e,(0,s._)("span",Le,(0,m.zw)(n.wagon.goldPrice),1)])):(0,s.kq)("",!0)])]),(0,s.Wm)(l,{visible:a.isVisible,title:"Purchase",onClose:t[5]||(t[5]=t=>e.hideModal())},{default:(0,s.w5)((()=>[Ge,(0,s._)("div",Ye,[(0,s._)("button",{onClick:t[3]||(t[3]=e=>i.buyWagon()),class:"modal-btn flex flex-auto"}," Confirm "),(0,s._)("button",{onClick:t[4]||(t[4]=(...t)=>e.hideModal&&e.hideModal(...t)),class:"modal-btn flex flex-auto"}," Cancel ")]),qe])),_:1},8,["visible"])],64)}var Ze={name:"ShopMenuType",props:{wagon:Object,model:String},data(){return{isVisible:!1,currType:null,gender:"male"}},computed:{...(0,O.rn)(["currencyType","activeWagon"]),isActive(){return this.active},useCash(){return this.currencyType<1||this.currencyType>1},useGold(){return this.currencyType>0}},methods:{openConfirmationModal(e){this.isVisible=!0,this.currType=e},loadWagon(){this.activeWagon&&this.$store.dispatch("setSelectedWagon",null),A.post("LoadWagon",{WagonModel:this.model})},buyWagon(){null!==this.currType&&A.post("BuyWagon",{ModelW:this.model,Cash:this.wagon.cashPrice,Gold:this.wagon.goldPrice,IsCash:this.currType})}},components:{ConfirmationModal:be}};const ze=(0,c.Z)(Ze,[["render",He],["__scopeId","data-v-624b2163"]]);var Ue=ze,Be={name:"ShopMenuItem",props:{wagon:Object,index:Number,selected:Number},emits:["iExpanded"],computed:{isOpen(){return this.index==this.selected}},methods:{Expand(){this.isOpen||this.$emit("iExpanded",this.index)}},components:{ShopMenuItemType:Ue}};const Ve=(0,c.Z)(Be,[["render",Oe],["__scopeId","data-v-e32c5394"]]);var Ke=Ve,Fe={name:"ShopMenu",data(){return{activeDropdown:-1}},methods:{onChildExpansion(e){this.activeDropdown=e}},components:{ShopMenuItem:Ke},computed:(0,O.rn)(["wagons"])};const Je=(0,c.Z)(Fe,[["render",ke]]);var Qe=Je,Xe={name:"HorseMenu",data(){return{page:"wagons",showModal:!1,isRotating:!1,rotateTimer:null}},components:{MenuButton:L,MyWagonMenu:Ce,ShopMenu:Qe},mounted(){window.addEventListener("mouseup",this.mouseUp,!1)},unmounted(){window.removeEventListener("mouseup",this.mouseUp)},methods:{close(){A.post("CloseMenu",{MenuAction:"Close"}).catch((e=>{console.log(e.message)}))},mouseUp(){this.isRotating=!1,this.stopRotate()},onMouseLeave(){this.stopRotate()},startRotate(e){this.rotate(e),this.isRotating=!0},stopRotate(){null!==this.rotateTimer&&(clearTimeout(this.rotateTimer),this.rotateTimer=null)},rotate(e){A.post("Rotate",{RotateWagon:e}),this.rotateTimer=setTimeout((()=>{this.rotate(e)}),30)}},computed:{...(0,O.rn)(["shopName"]),isClosed(){return null===this.activeHorse}}};const et=(0,c.Z)(Xe,[["render",D],["__scopeId","data-v-478943f9"]]);var tt=et;const nt=[{path:"/",name:"home",component:tt}],ot=(0,u.p7)({history:(0,u.r5)(),routes:nt});var st=ot,at=(0,O.MT)({state:{currencyType:2,myWagons:null,wagons:null,shopName:null,activeWagon:null},getters:{},mutations:{SET_MY_WAGONS(e,t){e.myWagons=t},SET_WAGONS(e,t){e.wagons=t},SET_SHOP_NAME(e,t){e.shopName=t},SET_ACTIVE_WAGON(e,t){e.activeWagon=t},SET_CURRENCY_TYPE(e,t){e.currencyType=t}},actions:{setMyWagons(e,t){e.commit("SET_MY_WAGONS",t)},setWagons(e,t){e.commit("SET_WAGONS",t)},setShopName(e,t){e.commit("SET_SHOP_NAME",t)},setSelectedWagon(e,t){e.commit("SET_ACTIVE_WAGON",t)},setCurrencyType(e,t){e.commit("SET_CURRENCY_TYPE",t)}},modules:{}});(0,o.ri)(d).use(at).use(st).mount("#app")}},t={};function n(o){var s=t[o];if(void 0!==s)return s.exports;var a=t[o]={exports:{}};return e[o](a,a.exports,n),a.exports}n.m=e,function(){var e=[];n.O=function(t,o,s,a){if(!o){var i=1/0;for(d=0;d<e.length;d++){o=e[d][0],s=e[d][1],a=e[d][2];for(var l=!0,c=0;c<o.length;c++)(!1&a||i>=a)&&Object.keys(n.O).every((function(e){return n.O[e](o[c])}))?o.splice(c--,1):(l=!1,a<i&&(i=a));if(l){e.splice(d--,1);var r=s();void 0!==r&&(t=r)}}return t}a=a||0;for(var d=e.length;d>0&&e[d-1][2]>a;d--)e[d]=e[d-1];e[d]=[o,s,a]}}(),function(){n.n=function(e){var t=e&&e.__esModule?function(){return e["default"]}:function(){return e};return n.d(t,{a:t}),t}}(),function(){n.d=function(e,t){for(var o in t)n.o(t,o)&&!n.o(e,o)&&Object.defineProperty(e,o,{enumerable:!0,get:t[o]})}}(),function(){n.g=function(){if("object"===typeof globalThis)return globalThis;try{return this||new Function("return this")()}catch(e){if("object"===typeof window)return window}}()}(),function(){n.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)}}(),function(){var e={143:0};n.O.j=function(t){return 0===e[t]};var t=function(t,o){var s,a,i=o[0],l=o[1],c=o[2],r=0;if(i.some((function(t){return 0!==e[t]}))){for(s in l)n.o(l,s)&&(n.m[s]=l[s]);if(c)var d=c(n)}for(t&&t(o);r<i.length;r++)a=i[r],n.o(e,a)&&e[a]&&e[a][0](),e[a]=0;return n.O(d)},o=self["webpackChunkui"]=self["webpackChunkui"]||[];o.forEach(t.bind(null,0)),o.push=t.bind(null,o.push.bind(o))}();var o=n.O(void 0,[998],(function(){return n(7249)}));o=n.O(o)})();
//# sourceMappingURL=app.76ae0362.js.map