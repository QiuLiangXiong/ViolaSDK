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
                                                     value:'https://timgs2a.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530606236618&di=ac19662b9b4d4170d64cdbc75c1d722a&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01006f55e2d00932f875a1328c5f44.gif',
                                   placeholder:'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530606299342&di=ed9920da188b43b713432c736f31ef95&imgtype=0&src=http%3A%2F%2Fpic2.16pic.com%2F00%2F20%2F02%2F16pic_2002642_b.jpg'
                                                     },
                                                     style: {
                                                     //                                    flexDirection: 'row',
                                                     //                                 flexWrap: 'wrap',
                                                     
                                                     
//                                                     position:'absolute',
//                                                     right:'10dp',
//                                                     bottom:'10dp',
//                                                     fontSize:'16dp',
//                                                     color:'blue',
                                   

//                                   backgroundColor:'yellow',
                                   
                                   aspectRatio:1.8,
                                   borderRadius:'10dp',
                                   margin:'10dp',
                                   borderColor:'yellow',
//                                   borderWidth:'10dp',
                                   
                                                     
                                                     //                                 borderRadius:'1000dp',
                                                     //                                 padding:'40dp',
                                                     animated: true,
                                                     }
                                                     })


container.appendChild(image);

var imageArray = ['https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530605724621&di=c5372a172d3dc65edd25a2325e0a8b7a&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01520856fc12636ac725794866fd27.gif',
                  'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530605724621&di=1666092893e145389366f060b7c6167f&imgtype=0&src=http%3A%2F%2Fwww.etaiyang.com%2Ffile%2Fupload%2F201610%2F07%2F11-21-06-29-12635.gif',
                   'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530605724619&di=7fcb6c6b34cbbf748fe0c83b89083b03&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01006f55e2d00932f875a1328c5f44.gif',
                  'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530606719762&di=e15bd430aea26c17ac199b669cf871fb&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0123205986fcfa0000002129ec6a7c.gif',
                   'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530605724617&di=020c8b0ba72091312ddc282ce78b6732&imgtype=0&src=http%3A%2F%2Fd.ifengimg.com%2Fw128%2Fp0.ifengimg.com%2Fpmop%2F2017%2F0710%2F3A6528751DBBE11294791593C3265E4C91EE7DC7_size968_w500_h259.gif',
                  'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530605724617&di=eae8ad53d0f7935f3bc1e2216611f742&imgtype=0&src=http%3A%2F%2Fp0.ifengimg.com%2Fpmop%2F2017%2F0822%2F24490F325E9E5E47F5F6A5FFFE0DCED944234B80_size1073_w640_h270.gif',
                  'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530605724616&di=5da3368c59d5402621b489f017f9514a&imgtype=0&src=http%3A%2F%2Fp0.ifengimg.com%2Fpmop%2F2017%2F0701%2FA7D94B702E843DF0D95B790390169C5F1118E224_size1669_w502_h295.gif',
                  'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530605724587&di=b82f5909542cf8313227de3339ce6ff4&imgtype=0&src=http%3A%2F%2Fp1.ifengimg.com%2Fa%2F2017_23%2F15964f84a01cbcf_size1542_w611_h336.gif',
                  'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530605889114&di=0267551c724f48a3868cff27c232fbd1&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Fgames%2Fcrawl%2F20160921%2Fc-Vc-fxvyqvy6954777.gif',
                  ]
var imageIndex = 0;
var ratioValues = [0.5,0.8,2,1];
image.on('click',function(e){
         image.setAttr('value',imageArray[++index % imageArray.length])
       //  image.setStyle({aspectRatio:ratioValues[index % 4]})
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

