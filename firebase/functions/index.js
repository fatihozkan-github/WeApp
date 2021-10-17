const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

exports.closeCover = functions.https.onRequest(async (req, res) => {
  await admin.database().ref("3566/IN_USE").set(true);
});
exports.openCover = functions.https.onRequest(async (req, res) => {
  await admin.database().ref("3566/IN_USE").set(false);
});

exports.usingTrue = functions.https.onRequest(async (req, res) => {
  await admin.database().ref("3566/IS_USING").set(true);
});

exports.usingFalse = functions.https.onRequest(async (req, res) => {
  await admin.database().ref("3566/IS_USING").set(false);
});

exports.onWeightAdded = functions.database
    .ref("/3566/WEIGHT_ADDED")
    .onUpdate((snapshot, context) => {
      const original = snapshot.before.val();
      const after = snapshot.after.val();
      functions.logger.log("Weight: ", original, "after: ", after);
    });
