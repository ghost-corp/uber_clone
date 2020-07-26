const functions = require('firebase-functions');
const admin = require("firebase-admin");
admin.initializeApp();


exports.sendMessageNotification = functions.firestore
    .document("users/{userId}/messages/{docId}").onCreate((messageContent,context)=>{
        const riderId = context.params.userId;
        const toId = messageContent.data().toId;
        var collection="";
        if(riderId==toId){
            collection="users";
        }else{
            collection="drivers";
        }
        
        admin.firestore().collection(collection)
            .doc(toId)
            .collection('tokens')
            .doc('deviceToken').get().then((tokenSnap)=>{
                var regToken=tokenSnap.data().token;
                var message = {
                    data:{
                        title: "New data message",
                        body: messageContent.data().message
                    },
                    token: regToken
                }
        
                return admin.messaging().send(message).then((response)=>{
                    console.log("Successfully sent message: ",response);
                }).catch((error=>{
                    console.log("Error sending message: ",error);
                }));
            });
    });
