import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as express from "express";
import * as cors from "cors";

admin.initializeApp();
const db = admin.firestore();

/**
 * Utility error response helper for consistent JSON errors.
 */
const sendError = (res: express.Response, status: number, message: string) => {
  functions.logger.warn("HTTP Error", { status, message });
  return res.status(status).json({ error: message });
};

/**
 * Validate a required string field.
 */
const requireString = (
  value: unknown,
  fieldName: string,
  res: express.Response
): string | null => {
  if (typeof value !== "string" || value.trim() === "") {
    sendError(res, 400, `Missing or invalid parameter: ${fieldName}`);
    return null;
  }
  return value.trim();
};

/**
 * Validate an optional array of strings.
 */
const requireStringArray = (
  value: unknown,
  fieldName: string,
  res: express.Response
): string[] | null => {
  if (!Array.isArray(value) || value.some((v) => typeof v !== "string")) {
    sendError(res, 400, `Missing or invalid parameter: ${fieldName}`);
    return null;
  }
  return value as string[];
};

/**
 * Express application handling all REST endpoints.
 */
const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

/**
 * Health endpoint for quick diagnostics.
 */
app.get("/health", (_req, res) => {
  res.status(200).json({ status: "ok" });
});

/**
 * GET /barbershop?uid=...
 * Returns whether a barbershop exists for the given owner UID.
 */
app.get("/barbershop", async (req, res) => {
  const uid = requireString(req.query.uid, "uid", res);
  if (!uid) return;

  try {
    const snapshot = await db
      .collection("barbershops")
      .where("ownerUserId", "==", uid)
      .limit(1)
      .get();

    if (snapshot.empty) {
      functions.logger.info("Barbershop lookup: none", { uid });
      return res.status(200).json({ exists: false });
    }

    const doc = snapshot.docs[0];
    functions.logger.info("Barbershop lookup: found", { uid, shopId: doc.id });
    return res.status(200).json({ exists: true, shopId: doc.id, data: doc.data() });
  } catch (error) {
    functions.logger.error("Error fetching barbershop", { error, uid });
    return sendError(res, 500, "Internal server error");
  }
});

/**
 * POST /barbershop
 * Body: { uid, name }
 */
app.post("/barbershop", async (req, res) => {
  const uid = requireString(req.body?.uid, "uid", res);
  const name = requireString(req.body?.name, "name", res);
  if (!uid || !name) return;

  try {
    const existing = await db
      .collection("barbershops")
      .where("ownerUserId", "==", uid)
      .limit(1)
      .get();

    if (!existing.empty) {
      const doc = existing.docs[0];
      functions.logger.info("Barbershop already exists", { uid, shopId: doc.id });
      return res.status(200).json({ shopId: doc.id, alreadyExists: true });
    }

    const createdAt = admin.firestore.FieldValue.serverTimestamp();
    const docRef = await db.collection("barbershops").add({
      ownerUserId: uid,
      name,
      createdAt,
    });

    functions.logger.info("Barbershop created", { uid, shopId: docRef.id });
    return res.status(201).json({ shopId: docRef.id });
  } catch (error) {
    functions.logger.error("Error creating barbershop", { error, uid });
    return sendError(res, 500, "Internal server error");
  }
});

/**
 * GET /operators?shopId=...
 * Returns all operators for a shop.
 */
app.get("/operators", async (req, res) => {
  const shopId = requireString(req.query.shopId, "shopId", res);
  if (!shopId) return;

  try {
    const snapshot = await db
      .collection("barbershops")
      .doc(shopId as string)
      .collection("operators")
      .get();

    const operators = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    functions.logger.info("Operators fetched", { shopId, count: operators.length });
    return res.status(200).json({ operators });
  } catch (error) {
    functions.logger.error("Error fetching operators", { error, shopId });
    return sendError(res, 500, "Internal server error");
  }
});

/**
 * POST /operators
 * Body: { shopId, name, servicesIds, workingHours }
 */
app.post("/operators", async (req, res) => {
  const shopId = requireString(req.body?.shopId, "shopId", res);
  const name = requireString(req.body?.name, "name", res);
  const servicesIds = requireStringArray(req.body?.servicesIds ?? [], "servicesIds", res);
  const workingHours = req.body?.workingHours ?? {};

  if (!shopId || !name || !servicesIds) return;

  if (typeof workingHours !== "object" || Array.isArray(workingHours)) {
    return sendError(res, 400, "Missing or invalid parameter: workingHours");
  }

  try {
    const docRef = await db
      .collection("barbershops")
      .doc(shopId)
      .collection("operators")
      .add({ name, servicesIds, workingHours });

    functions.logger.info("Operator created", { shopId, operatorId: docRef.id });
    return res.status(201).json({ operatorId: docRef.id });
  } catch (error) {
    functions.logger.error("Error creating operator", { error, shopId });
    return sendError(res, 500, "Internal server error");
  }
});

/**
 * GET /services?shopId=...
 * Returns all services for a shop.
 */
app.get("/services", async (req, res) => {
  const shopId = requireString(req.query.shopId, "shopId", res);
  if (!shopId) return;

  try {
    const snapshot = await db
      .collection("barbershops")
      .doc(shopId as string)
      .collection("services")
      .get();

    const services = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    functions.logger.info("Services fetched", { shopId, count: services.length });
    return res.status(200).json({ services });
  } catch (error) {
    functions.logger.error("Error fetching services", { error, shopId });
    return sendError(res, 500, "Internal server error");
  }
});

/**
 * POST /services
 * Body: { shopId, name, durationMinutes, price }
 */
app.post("/services", async (req, res) => {
  const shopId = requireString(req.body?.shopId, "shopId", res);
  const name = requireString(req.body?.name, "name", res);
  const durationMinutes = req.body?.durationMinutes;
  const price = req.body?.price;

  if (!shopId || !name) return;
  if (typeof durationMinutes !== "number" || durationMinutes <= 0) {
    return sendError(res, 400, "Missing or invalid parameter: durationMinutes");
  }
  if (typeof price !== "number" || price < 0) {
    return sendError(res, 400, "Missing or invalid parameter: price");
  }

  try {
    const docRef = await db
      .collection("barbershops")
      .doc(shopId)
      .collection("services")
      .add({ name, durationMinutes, price });

    functions.logger.info("Service created", { shopId, serviceId: docRef.id });
    return res.status(201).json({ serviceId: docRef.id });
  } catch (error) {
    functions.logger.error("Error creating service", { error, shopId });
    return sendError(res, 500, "Internal server error");
  }
});

/**
 * GET /bookings?shopId=...&date=YYYY-MM-DD
 * Returns bookings filtered by a calendar day based on startTime.
 */
app.get("/bookings", async (req, res) => {
  const shopId = requireString(req.query.shopId, "shopId", res);
  const date = requireString(req.query.date, "date", res);
  if (!shopId || !date) return;

  if (!/^\d{4}-\d{2}-\d{2}$/.test(date)) {
    return sendError(res, 400, "date must be in format YYYY-MM-DD");
  }

  try {
    const startOfDay = new Date(`${date}T00:00:00.000Z`);
    const endOfDay = new Date(`${date}T23:59:59.999Z`);

    const snapshot = await db
      .collection("barbershops")
      .doc(shopId as string)
      .collection("bookings")
      .where("startTime", ">=", startOfDay)
      .where("startTime", "<=", endOfDay)
      .get();

    const bookings = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    functions.logger.info("Bookings fetched", { shopId, count: bookings.length, date });
    return res.status(200).json({ bookings });
  } catch (error) {
    functions.logger.error("Error fetching bookings", { error, shopId, date });
    return sendError(res, 500, "Internal server error");
  }
});

/**
 * POST /bookings
 * Body: { shopId, customerName, customerPhone, serviceId, operatorId, startTime, notes }
 * endTime is computed using the durationMinutes of the service.
 */
app.post("/bookings", async (req, res) => {
  const shopId = requireString(req.body?.shopId, "shopId", res);
  const customerName = requireString(req.body?.customerName, "customerName", res);
  const customerPhone = requireString(req.body?.customerPhone, "customerPhone", res);
  const serviceId = requireString(req.body?.serviceId, "serviceId", res);
  const operatorId = requireString(req.body?.operatorId, "operatorId", res);
  const startTimeStr = requireString(req.body?.startTime, "startTime", res);
  const notes = typeof req.body?.notes === "string" ? req.body.notes : "";

  if (!shopId || !customerName || !customerPhone || !serviceId || !operatorId || !startTimeStr) return;

  const startTime = new Date(startTimeStr);
  if (isNaN(startTime.getTime())) {
    return sendError(res, 400, "startTime must be a valid ISO date string");
  }

  try {
    const serviceSnap = await db
      .collection("barbershops")
      .doc(shopId)
      .collection("services")
      .doc(serviceId)
      .get();

    if (!serviceSnap.exists) {
      return sendError(res, 400, "Service not found for provided serviceId");
    }

    const serviceData = serviceSnap.data();
    const durationMinutes = serviceData?.durationMinutes;
    if (typeof durationMinutes !== "number" || durationMinutes <= 0) {
      return sendError(res, 500, "Invalid service duration configuration");
    }

    const endTime = new Date(startTime.getTime() + durationMinutes * 60000);

    const bookingPayload = {
      customerName,
      customerPhone,
      serviceId,
      operatorId,
      startTime,
      endTime,
      notes,
    };

    const docRef = await db
      .collection("barbershops")
      .doc(shopId)
      .collection("bookings")
      .add(bookingPayload);

    functions.logger.info("Booking created", { shopId, bookingId: docRef.id, operatorId });
    return res.status(201).json({ bookingId: docRef.id, endTime: endTime.toISOString() });
  } catch (error) {
    functions.logger.error("Error creating booking", { error, shopId });
    return sendError(res, 500, "Internal server error");
  }
});

/**
 * Global error handler to ensure JSON responses.
 */
app.use((err: Error, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  functions.logger.error("Unhandled error", { error: err.message, stack: err.stack });
  sendError(res, 500, "Internal server error");
});

/**
 * Firebase HTTPS function export.
 */
export const api = functions.https.onRequest(app);
