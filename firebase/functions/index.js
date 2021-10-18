/* eslint-disable promise/no-nesting */
/* eslint-disable promise/catch-or-return */
/* eslint-disable promise/always-return */
/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.closeCover = functions.https.onRequest(async (req, res) => {
  return admin
    .database()
    .ref("3566/IN_USE")
    .set(false)
    .then(() => {
      console.log("Cover close completed!");
      res.send("Completed!");
    });
});
exports.openCover = functions.https.onRequest(async (req, res) => {
  return admin
    .database()
    .ref("3566/IN_USE")
    .set(true)
    .then(() => {
      console.log("Cover open completed!");
      res.send("Completed!");
    });
});
exports.getUserIdFromRf = functions.https.onRequest(
  async (request, response) => {
    const rfId = request.query.rfId;
    if (rfId !== null) {
      admin
        .firestore()
        .collection("users")
        .where("rfId", "==", rfId)
        .get()
        .then((snapshot) => {
          if (!snapshot.empty) {
            snapshot.forEach((doc) => {
              const user = doc.data();
              const uid = user.uid;
              response.send(uid);
            });
          } else {
            response.sendStatus(403);
          }
        })
        .catch((e) => console.log("Bulunamadi: ", e));
    } else {
      response.sendStatus(404);
    }
  }
);
exports.rewardUser = functions.https.onRequest(
  async (request, response) => {
    const rfId = request.query.rfId;
    const weight = request.query.weight;
    if (rfId !== null && weight!==null) {
      admin
        .firestore()
        .collection("users")
        .where("rfId", "==", rfId)
        .get()
        .then((snapshot) => {
          if (!snapshot.empty) {
            snapshot.forEach((doc) => {
              const user = doc.data();
              const uid = user.uid;
              const coins = (parseInt(user.coins) + 2 * parseInt(weight));
              const recycled = parseInt(user.recycled) + parseInt(weight);
              admin.firestore().collection("users").doc(uid).update({
                coins: coins,
                recycled:recycled 
              });
              admin.database().ref("3566/RFID_TEMP").set('').then(() => {
                console.log("RFID: ", rfId," Weight: ", weight, " User: ", uid);
                response.send('OK');
              });
            });
          } else {
            response.sendStatus(403);
          }
        })
        .catch((e) => console.log("Bulunamadi: ", e));
    } else {
      response.sendStatus(404);
    }
  }
);
/*
exports.pairUserWithRF = functions.database
  .ref("/3566/RFID_TEMP")
  .onUpdate((snapshot, context) => {
    const rf_temp = snapshot.after.val();
    if (rf_temp !== "") {
      admin
        .firestore()
        .collection("users")
        .where("rfId", "==", rf_temp)
        .get()
        .then((snapshot) => {
          if (snapshot.empty) {
            // RF daha once eslesmemis
            admin
              .database()
              .ref("/3566/UID")
              .once("value")
              .then((snapshot) => {
                const uid = snapshot.val();
                if (uid !== "") {
                  functions.logger.info("Timestamp: ", context.timestamp);
                  admin.firestore().collection("users").doc(uid).update({
                    rfId: rf_temp,
                  });
                  admin
                    .database()
                    .ref("3566/LAST_READ_TIME")
                    .set(context.timestamp);
                  admin.database().ref("3566/UID").set("");
                  admin.database().ref("3566/RFID_TEMP").set("");
                  return;
                } else {
                  functions.logger.info("UID bos!!");
                  return;
                }
              });
          } else {
            functions.logger.info("RF Exist!!");
            return;
          }
        });
    } else {
      functions.logger.info("bos la bu!!");
      return;
    }
  });


exports.onWeightUpdated = functions.database
  .ref("/3566/WEIGHT_ADDED")
  .onUpdate((snapshot, context) => {
    const original = snapshot.before.val();
    const after = snapshot.after.val();
    functions.logger.log("Weight: ", original, "after: ", after);
  });

exports.onUidUpdated = functions.database
  .ref("/3566/UID")
  .onUpdate(async (snapshot, context) => {
    const userId = snapshot.after.val();
    if (userId !== "") {
      admin
        .firestore()
        .collection("users")
        .where("uid", "==", userId)
        .get()
        .then((snapshot) => {
          if (!snapshot.empty) {
            snapshot.forEach((doc) => {
              const user = doc.data();
              functions.logger.info("User: ", user);
              admin
                .database()
                .ref("/3566/WEIGHT_ADDED")
                .get()
                .then((snapshot) => {
                  const weight = snapshot.val();
                  if (weight !== 0) {
                    functions.logger.info("Timestamp: ", context.timestamp);
                    admin
                      .firestore()
                      .collection("users")
                      .where("uid", "==", userId)
                      .update({
                        coins: parseInt(user.coins + 2 * weight),
                        recycled: parseInt(user.recycled + weight),
                      })
                      .catch((e) => console.log("update failed: ", e));
                    functions.logger.info("coins: ", {
                      coins: parseInt(user.coins + 2 * weight),
                      recycled: parseInt(user.recycled + weight),
                    });
                    return admin
                      .database()
                      .ref("3566/LAST_READ_TIME")
                      .set(context.timestamp);
                  } else {
                    return functions.logger.info("Weight zero");
                  }
                })
                .catch((e) => console.log("WEIGHT_ADDED bos: ", e));
            });
          } else {
            functions.logger.info("User Null: ", userId);
          }
        })
        .catch((e) => console.log("Bulunamadi: ", e));
    }
  });
*/