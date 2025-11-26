import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

// ==============================
// 🔥 GET AVAILABLE SLOTS
// ==============================
export const getAvailableSlots = functions.https.onCall(
  async (data, context) => {
    const date = data.date as string;
    const serviceIds = data.serviceIds as string[];
    const operatorId = (data.operatorId as string) ?? null;

    if (!date || !serviceIds) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing required parameters: date, serviceIds"
      );
    }

    console.log("REQUEST SLOTS:", { date, serviceIds, operatorId });

    // Mock di esempio — sostituirai con Firestore
    return [
      {
        start: `${date}T09:00:00.000Z`,
        end: `${date}T09:30:00.000Z`,
        available: true,
      },
      {
        start: `${date}T09:30:00.000Z`,
        end: `${date}T10:00:00.000Z`,
        available: true,
      },
    ];
  }
);

// ==============================
// 🔥 CREATE BOOKING
// ==============================
export const createBooking = functions.https.onCall(
  async (data, context) => {
    const booking = {
      customerId: data.customerId,
      customerName: data.customerName,
      customerEmail: data.customerEmail,
      serviceIds: data.serviceIds,
      startTime: data.startTime,
      notes: data.notes ?? null,
      operatorId: data.operatorId ?? null,
    };

    console.log("CREATE BOOKING:", booking);

    // Mock: salverai su Firestore
    return {
      success: true,
      bookingId: "mock-id-123",
      ...booking,
    };
  }
);
