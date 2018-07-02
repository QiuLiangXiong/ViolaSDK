//
//new Vue({
//        el: 'test',
//        data: {
//            attr: {
//                id: 'viola-id',
//                more: 'about'
//            },
//            text: '我们都是好孩子',
//            style: {
//                backgroundColor: 'red',
//                flex: 1
//            }
//        },
//        methods: {
//        handlerClick: function (e) {
//            console.log(e)
//            this.text = 'hhhhhhhhh'
//        }
//        },
//        render: function (h) {
//            return h('div', {
//                     style: this.style,
//                     attrs: this.attr,
//                     on: {
//                     click: this.handlerClick
//                     }
//             }, [this.text])
//        }
//})
//
//
//
//return;



var container = document.createElement('div', {
                                       attr: { id: 'container' }
                                       })

var textContainer = document.createElement('div', {
     style: {
           flexDirection: 'row',
//           flexWrap: 'wrap',
           borderColor:'rgba(255,255,255,0.3)',
           backgroundColor:'green',
           margin:'20dp',
           borderWidth:'10dp',
           padding:'0dp',
           animated: true,
    }
})

var div = document.createElement('text', {
                                 events:['click','lastLineMarginChange'],
                                 attr: {
                                 id: 'div1',
                                 value:'们都是好孩子我们都是好孩子我们都是好孩子我们都是好孩子我们都是好孩子我们都是好孩子我们都是好孩子我们都是好孩子',
                                 },
                                 style: {
//                                    flexDirection: 'row',
//                                 flexWrap: 'wrap',
//                                 borderColor:'r',
                                     backgroundColor:'red',

//                                 maxWidth:'200dp',
//                                 borderWidth:'10dp',

                                 
//                                 borderRadius:'1000dp',
//                                 padding:'40dp',
                                 animated: true,
                                 lines:4,
                                 fontSize:'16dp',
                                 lineBreakMargin:'70dp',
                                 
//                                 lineHeight:'40dp',
                               //  lineSpacing:'10dp',
//                                 headIndent:'20dp',


//                                 lineHeight:'30dp',
//                                 lineSpacing:'-20dp',
                                    }
                                 })

// window.div = div.ref
var zhankaiText = document.createElement('text', {
                                  
                                 attr: {
                                 id: 'div2',
                                 value:'全文展开',
                                 },
                                 style: {
                                 //                                    flexDirection: 'row',
                                 //                                 flexWrap: 'wrap',


                                  position:'absolute',
                                  right:'10dp',
                                  bottom:'10dp',
                                  fontSize:'16dp',
                                  color:'blue',




                                 //                                 borderRadius:'1000dp',
                                 //                                 padding:'40dp',
                                 animated: true,
                                 }
                                 })

var index = 0;
div.on('lastLineMarginChange',function(e){
       console.log(e);
       })
div.on('click', function (e) {
       console.log(e);


       var value = [
                    '我们都是好孩子',
                    '长一点长一长一点长长一点长长一点长长一点长',
                    '短一点点点',
                    '不短了不短了不短了长一点长长一点长长一点长不短了长一点不短了长一点不短了长一点不短了长一点',
                    ]
//        this.setAttr('value', value[parseInt(++index%3)])
       var values = [ {text:value[parseInt(++index%4)],color:'blue'},{highlightBackgroundColor:'rgba(0,0,0,0.4)',highlightBackgroundInset:'{3dp,0dp,3dp,0dp}',highlightBackgroundRadius:'4dp', text:value[parseInt(++index%4)], color:'yellow',fontSize:'16dp',textDecoration:'underline',},{highlightBackgroundColor:'rgba(255,255,255,0.4)',highlightBackgroundInset:'{3dp,0dp,3dp,0dp}',highlightBackgroundRadius:'4dp',text:value[parseInt(++index%4)],color:'black', textDecoration:'line-through'}];
       
       this.setAttr('values', values)
       this.setStyle({

                     color:'white',
//                     fontWeight:'bold',
//                     maxWidth:'400dp',
//                     textDecoration:'line-through',

                     
                     
       })
})

div.on('lineBreakChange',function(e){
        console.log('lineBreakChang___'+JSON.stringify(e));
       console.log('_____good___\n tom is good boy')
       if(e.isLineBreak){
       zhankaiText.setStyle({'visibility':'visible'});

       }else {
       zhankaiText.setStyle({'visibility':'hidden'});
       }

       
       }
       );

textContainer.appendChild(div)
textContainer.appendChild(zhankaiText)

container.appendChild(textContainer)


var image = document.createElement('image', {
                                                     
                                                     attr: {
                                                     id: 'image2',
                                   resize:'cover',
                                                     value:'https://ss1.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=f560166a52df8db1a32e7a643922dddb/0ff41bd5ad6eddc4f8daa30935dbb6fd52663306.jpg',
                                   placeholder:'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530543710813&di=d27902729d11bce986ce2f03d50c7b42&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fb7fd5266d0160924592977e8d80735fae6cd3431.jpg'
                                                     },
                                                     style: {
                                                     //                                    flexDirection: 'row',
                                                     //                                 flexWrap: 'wrap',
                                                     
                                                     
//                                                     position:'absolute',
//                                                     right:'10dp',
//                                                     bottom:'10dp',
//                                                     fontSize:'16dp',
//                                                     color:'blue',
                                   

                                   backgroundColor:'yellow',
                                   
                                   aspectRatio:1,
                                   borderRadius:'40dp',
                                   margin:'20dp',
                                   borderColor:'yellow',
                                   borderWidth:'10dp',
                                                     
                                                     
                                                     //                                 borderRadius:'1000dp',
                                                     //                                 padding:'40dp',
                                                     animated: true,
                                                     }
                                                     })


container.appendChild(image);

var imageArray = ['https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530543710813&di=96d5365b426fa140761a173c6ee92ff1&imgtype=0&src=http%3A%2F%2Fa.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Ffc1f4134970a304eb5088f73ddc8a786c9175c14.jpg',
                  'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530543710813&di=7ccc90179f0b0a24601fb85c76b7efb6&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F37d3d539b6003af33cd1a3ee392ac65c1138b6d0.jpg',
                   'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530543710813&di=97c9b207624e8fe56d2b3cbd74e2e051&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fb7003af33a87e95053e42ae21c385343faf2b449.jpg',
                   'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530543710813&di=5256b51d3b6b78e59626f0973f66d468&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fb8014a90f603738d1f357dacbf1bb051f919ecc5.jpg',
                  ]
var imageIndex = 0;
var ratioValues = [0.5,0.8,2,1];
image.on('click',function(e){
         image.setAttr('value',imageArray[++index % 4])
         image.setStyle({aspectRatio:ratioValues[index % 4]})
         })

//container.appendChild(div)

var div2 = document.createElement('div')

div2.setAttr('id', 'div2')

div2.setStyle({
              width: '200dp',
              height: '200dp',
              backgroundColor:'yellow',
              margin:'20dp',
              animated: true
              })

// window.div2 = div2.ref

var color = ['#d55353', '#2795ee', '#00bdb8']
var width = [100, 150, 175]
var height = [206, 110, 75]
var radius = [50, 10, 32, 100]

function getStyle () {
    var c = color.shift()
    color.push(c)
    var w = width.shift()
    width.push(w)
    var h = height.shift()
    height.push(h)
    var r = radius.shift()
    radius.push(r)
    return {
    backgroundColor: c,
    width: w,
    height: h,
    borderTopLeftRadius: radius[0],
    borderTopRightRadius: radius[1],
    borderBottomLeftRadius: radius[2],
    borderBottomRightRadius: radius[3],


    }
}
// updateElement
div2.on('click', function () {
        this.setStyle(getStyle())
        })

container.appendChild(div2)

// move
var div3 = document.createElement('div', {
                                  style: {
                                  flexDirection: 'row',
                                  width: 600,
                                  height: 100,
                                  backgroundColor:'blue',
                                  margin:'20dp',
                                  animated: true
                                  },
                                  events: {
                                  click: function () {
                                  var f = this.children[0]
                                  var l = this.children[this.children.length - 1]
                                  this.insertBefore(l, f)
                                  }
                                  }
                                  })

div3.setAttr('id', 'div3')

// window.div3 = div3.ref

for(var i = 0; i < 3; i++) {
    div3.appendChild(document.createElement('div', {
                                            style: {
                                            width: 150,
                                            height: 60,
                                            margin: '10dp',
                                            backgroundColor: color[i],
                                            animated: true
                                            }
                                            }))
}

container.appendChild(div3)

var btnGroup = document.createElement('div', {
                                      style: {
                                      backgroundColor: 'black',
                                      flexDirection: 'row',
                                      justifyContent: 'space-between'
                                      }
                                      })

var div4 = document.createElement('div', {
                                  style: {
                                  width: 100,
                                  height: 100,
                                  backgroundColor:'white',
                                  margin:'10dp',
                                  animated: true
                                  },
                                  events: {
                                  click: function () {
                                  div.appendChild(document.createElement('div', {
                                                                         style: Object.assign({
                                                                                              width: 30,
                                                                                              height: 30,
                                                                                              margin: '10dp',
                                                                                              animated: true
                                                                    }, getStyle())
                                         }))
                                  }
                                  }
                                  })

div4.setAttr('id', 'div4')
// window.div4 = div4.ref

btnGroup.appendChild(div4)

var div5 = document.createElement('div', {
                                  style: {
                                  width: 100,
                                  height: 100,
                                  backgroundColor:'green',
                                  margin:'10dp',
                                  animated: true
                                  },
                                  events: {
                                  click: function () {
                                    if (div.children.length === 0) return
                                    div.removeChild(div.children[div.children.length - 1])
                                  }
                                  }
                                  })

div5.setAttr('id', 'div5')
// window.div4 = div4.ref

btnGroup.appendChild(div5)

container.appendChild(btnGroup)

document.body.setStyle({
                       backgroundColor: 'grey'
})

document.body.type = 'div'

document.body.appendChild(container)
document.render()




//
//var div = document.createElement('div', {
//                                 attr: {
//                                 id: 'div1'
//                                 },
//                                 style: {
//                                 backgroundColor:'white',
//                                 }
//                                 })
//
//div.on('click', function (e) {
//       console.log({title: 'here is div', event: e})
//       })
//
//var child = document.createElement('div')
//
//child.setStyle({
//               backgroundColor:'red',
//               margin:'20dp',
// borderTopLeftRadius:25,
//                                                       borderBottomRightRadius:25,
//                                                       borderBottomLeftRadius:25,
//                                                        borderTopRightRadius:25,
//               borderWidth:'5px',
//               borderColor:'blue',
//               borderStyle:'dashed',
//               })
//
//child.appendChild(document.createElement('div', {
//                                         style: {
////                                         backgroundColor:'#07D0B0',
//                                         height:'13dp',
//                                         width:'25dp',
//                                         margin:'20dp',
//                                         borderRadius:'4dp',
//                                         borderWidth:'0.5',
//                                         borderColor:'blue',
////                                         borderTopLeftRadius:2000,
////                                        borderBottomRightRadius:2000,
////                                        borderBottomLeftRadius:1000,
////                                         borderTopRightRadius:1000,
//                                         },
//                                         events: {
//                                         click: function (e) {
//                                            console.log({title: 'here is blue', event: e})
//                                            e.stopPropagation()
//                                         }
//                                         }
//                                         }))
//
//div.appendChild(child)
//
//document.body.appendChild(div)
//document.render()
////
////
////var ele =  {ref:1,type:'div',style:{backgroundColor:'brown'},
////           children:[
////                  {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'19',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'20',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                   },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
////                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
////                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
////
////                                     }],
////                               }],
////                     },
////
////
////              ]
////            }
////callNative(1,[{module:'dom',method:'createBody',args:[ele]}])
////
////
////
////setTimeout(function(){
//////           callNative(1,[{module:'dom',method:'updateComponent',args:[{animated:1 ,ref:'20',style:{height:'500px'}}]}]);
////          // callNative(1,[{module:'dom',method:'removeComponent',args:['20',true] } ]);
////           var ele = {animated:true, ref:'21',type:'div',event:['click','doubleClick','longPress'],style:{backgroundColor:'black',margin:'20dp',height:'300px'}};
////                      callNative(1,[{module:'dom',method:'addComponent',args:['19',ele,-1,true] } ]);
//////           'swipeLeft','swipeRight','swipeTop','swipeBottom','click','doubleClick','longPress'
//////           callNative(1,[{module:'dom',method:'updateComponent',args:[{animated:1 ,ref:'20',style:{height:'500px',backgroundColor:'black'},event:['click','pan']}]}] );
////
////           },500);
////
////
////function createInstance(instanceId,data){
////
////}
////
////
////function callJS(id,tasks){
////    nativeLog(JSON.stringify(tasks));
////}
////

