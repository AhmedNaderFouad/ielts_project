import {onRequest} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as nodemailer from "nodemailer";
import * as crypto from "crypto";

admin.initializeApp();
const db = admin.firestore();

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "ielts.for.all.learner@gmail.com",
    pass: "vjqd jaym tbpr unjg",
  },
});

export const sendPasswordResetOTP = onRequest(
  {cors: true},
  async (req, res) => {
    const {email} = req.body;
    if (!email) {
      res.status(400).send({error: "Email is required"});
      return;
    }

    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const hashedOtp = crypto.createHash("sha256").update(otp).digest("hex");
    const expiresAt = Date.now() + 5 * 60 * 1000;

    try {
      await db.collection("password_resets").doc(email).set({
        hashedOtp,
        expiresAt,
        attempts: 0,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      await transporter.sendMail({
        from: "\"IELTS Prep App\" <ielts.for.all.learner@gmail.com>",
        to: email,
        subject: "Your Verification Code",
        html: `
          <div style="font-family: Arial, sans-serif; padding: 20px;">
            <h2>Verification Code</h2>
            <p>Your 6-digit OTP code is:</p>
            <h1 style="color: #4F46E5; letter-spacing: 4px;">${otp}</h1>
            <p>This code expires in 5 minutes. Do not share it with anyone.</p>
          </div>
        `,
      });

      res.status(200).send({success: true, message: "OTP sent successfully"});
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : "Unknown error";
      res.status(500).send({error: message});
    }
  }
);

export const verifyOTP = onRequest({cors: true}, async (req, res) => {
  try {
    const {email, code, userId} = req.body;
    if (!email || !code) {
      res.status(400).send({error: "Email and code are required"});
      return;
    }

    const docRef = db.collection("password_resets").doc(email);
    const doc = await docRef.get();

    if (!doc.exists) {
      res.status(404).send({error: "No OTP requested for this email"});
      return;
    }

    const data = doc.data();
    if (!data) {
      res.status(404).send({error: "Data not found"});
      return;
    }

    if (Date.now() > data.expiresAt) {
      res.status(400).send({error: "OTP code has expired"});
      return;
    }

    const hashedInput = crypto.createHash("sha256").update(code).digest("hex");

    if (hashedInput !== data.hashedOtp) {
      await docRef.update({attempts: admin.firestore.FieldValue.increment(1)});
      res.status(400).send({error: "Invalid verification code"});
      return;
    }

    // Update user document in Firestore if userId is provided
    if (userId) {
      await db.collection("users").doc(userId).update({
        isEmailVerified: true,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    const resetToken = crypto.randomBytes(32).toString("hex");
    await docRef.update({isVerified: true, resetToken});

    res.status(200).send({success: true, resetToken});
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : "Unknown error";
    res.status(500).send({error: message});
  }
});

export const resetPassword = onRequest({cors: true}, async (req, res) => {
  try {
    const {email, resetToken, newPassword} = req.body;

    if (!email || !resetToken || !newPassword) {
      res.status(400).send({
        error: "Email, resetToken and newPassword are required",
      });
      return;
    }

    const docRef = db.collection("password_resets").doc(email);
    const doc = await docRef.get();

    if (!doc.exists) {
      res.status(404).send({error: "Invalid reset session"});
      return;
    }

    const data = doc.data();
    if (!data || !data.isVerified || data.resetToken !== resetToken) {
      res.status(401).send({error: "Unauthorized or invalid reset token"});
      return;
    }

    const user = await admin.auth().getUserByEmail(email);
    await admin.auth().updateUser(user.uid, {password: newPassword});
    await docRef.delete();

    res.status(200).send({
      success: true,
      message: "Password updated successfully",
    });
  } catch (error: unknown) {
    const message = error instanceof Error ?
      error.message :
      "Failed to update password";
    res.status(500).send({error: message});
  }
});
