

var ele =  {ref:1,type:'div',style:{backgroundColor:'brown'},
           children:[
                  {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
                     children:[{ref:'19',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
                           children:[{ref:'20',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
                                     
                                     }],
                               }],
                   },
                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
                                     
                                     }],
                               }],
                     },
                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
                                     
                                     }],
                               }],
                     },
                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
                                     
                                     }],
                               }],
                     },
                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
                                     
                                     }],
                               }],
                     },
                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
                                     
                                     }],
                               }],
                     },
                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
                                     
                                     }],
                               }],
                     },
                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
                                     
                                     }],
                               }],
                     },
                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
                                     
                                     }],
                               }],
                     },
                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
                                     
                                     }],
                               }],
                     },
                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
                                     
                                     }],
                               }],
                     },
                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
                                     
                                     }],
                               }],
                     },
                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
                                     
                                     }],
                               }],
                     },
                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
                                     
                                     }],
                               }],
                     },
                     {ref:'1',type:'div',style:{backgroundColor:'red',margin:'20dp'},
                     children:[{ref:'1',type:'div',style:{backgroundColor:'yellow',margin:'20dp'},
                           children:[{ref:'1',type:'div',style:{backgroundColor:'blue',height:'200px',margin:'20dp'},
                                     
                                     }],
                               }],
                     },
                    
               
              ]
            }
callNative(1,[{module:'dom',method:'createBody',args:[ele]}])



setTimeout(function(){
//           callNative(1,[{module:'dom',method:'updateComponent',args:[{animated:1 ,ref:'20',style:{height:'500px'}}]}]);
          // callNative(1,[{module:'dom',method:'removeComponent',args:['20',true] } ]);
           var ele = {animated:true, ref:'21',type:'div',event:['click','doubleClick','longPress'],style:{backgroundColor:'black',margin:'20dp',height:'300px'}};
                      callNative(1,[{module:'dom',method:'addComponent',args:['19',ele,-1,true] } ]);
//           'swipeLeft','swipeRight','swipeTop','swipeBottom','click','doubleClick','longPress'
//           callNative(1,[{module:'dom',method:'updateComponent',args:[{animated:1 ,ref:'20',style:{height:'500px',backgroundColor:'black'},event:['click','pan']}]}] );
           
           },500);


function createInstance(instanceId,data){
    
}


function callJS(id,tasks){
    nativeLog(JSON.stringify(tasks));
}

