/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const {google} = require("googleapis");
const {DateTime} = require("luxon");
const axios = require("axios");
const cors = require("cors")({origin: true});

require("dotenv").config();
/*
const googleApiKey =
    functions.config().secrets.GOOGLE_API_KEY ||
    process.env.GOOGLE_API_KEY;
*/
let googleApiKey;

try {
  console.log(
      "Attempting to load GOOGLE_API_KEY from Firebase Secrets or .env...",
  );

  // Check if functions.config().secrets exists, then access GOOGLE_API_KEY
  googleApiKey = (functions.config().secrets &&
    functions.config().secrets.GOOGLE_API_KEY) ||
    process.env.GOOGLE_API_KEY;

  if (googleApiKey) {
    console.log(
        "GOOGLE_API_KEY loaded successfully:",
        googleApiKey ? "Exists" : "Not found",
    );
  } else {
    console.warn("GOOGLE_API_KEY is not set in Firebase Secrets or .env file");
  }
} catch (error) {
  console.error("Error accessing GOOGLE_API_KEY:", error);
}

// Initialize Firebase Admin SDK
admin.initializeApp();

// Configure Nodemailer to use Gmail
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

// Load Google Calendar API credentials
const serviceAccount = require("./keys/serviceAccountKey.json");
const SCOPES = ["https://www.googleapis.com/auth/calendar"];

// Create a Google Calendar API client
const auth = new google.auth.JWT(
    serviceAccount.client_email,
    null,
    serviceAccount.private_key,
    SCOPES,
);
const calendar = google.calendar({version: "v3", auth});

/**
 * Function to format the date as "August 27th"
 * @param {Date} date - JavaScript Date object
 * @return {string} - Formatted date with ordinal suffix
 */
function formatDateWithOrdinal(date) {
  const day = date.day;
  const ordinalSuffix = getOrdinalSuffix(day);

  const formattedDate = date.toLocaleDateString("en-US", {
    month: "long",
    day: "numeric",
  });

  return `${formattedDate}${ordinalSuffix}`;
}

/**
 * Function to get the ordinal suffix for a number (1st, 2nd, 3rd, etc.)
 * @param {number} day - Day of the month
 * @return {string} - Ordinal suffix (th, st, nd, rd)
 */
function getOrdinalSuffix(day) {
  if (day > 3 && day < 21) return "th"; // Covers 11th, 12th, 13th
  switch (day % 10) {
    case 1: return "st";
    case 2: return "nd";
    case 3: return "rd";
    default: return "th";
  }
}

/**
 * Combine the selectedDate and selectedTime into a single Luxon DateTime object
 *
 * @param {string} dateString - The date in YYYY-MM-DD format.
 * @param {string} timeString - The time in 12-hour format with AM/PM.
 * @return {DateTime} - A Luxon DateTime object.
 */
function combineDateAndTime(dateString, timeString) {
  const [time, modifier] = timeString.split(" ");
  let [hours, minutes] = time.split(":");

  // Convert hours to an integer
  hours = parseInt(hours, 10);

  // Adjust hours for AM/PM
  if (modifier === "PM" && hours !== 12) {
    hours += 12;
  } else if (modifier === "AM" && hours === 12) {
    hours = 0;
  }

  // Ensure hours and minutes are strings for padStart
  const hoursString = String(hours).padStart(2, "0");
  const minutesString = String(minutes).padStart(2, "0");

  // Construct the ISO datetime string
  const dateTimeString = `${dateString}T${hoursString}:${minutesString}:00`;

  // Use Luxon to create a DateTime object with the appropriate time zone
  return DateTime.fromISO(dateTimeString, {zone: "America/New_York"});
}

// Firestore trigger to listen for new bookings
exports.sendBookingEmailAndAddToCalendar = functions.firestore
    .document("bookings/{bookingId}")
    .onCreate((snap, context) => {
      const bookingData = snap.data();
      const bookingId = context.params.bookingId;
      const animalList = bookingData.selectedAnimals.join(", ");

      // Check if selectedDate and selectedTime exist
      if (!bookingData.selectedDate || !bookingData.selectedTime) {
        console.error("Missing selectedDate or selectedTime in booking data");
        return;
      }

      // Combine selectedDate and selectedTime
      const startDateTime = combineDateAndTime(
          bookingData.selectedDate.split("T")[0],
          bookingData.selectedTime,
      );

      // Convert Luxon DateTime to JS Date for native JavaScript usage
      const startDateTimeJS = startDateTime.toJSDate();

      // Format the date with ordinal for user email
      const formattedDate = formatDateWithOrdinal(startDateTimeJS);

      // Check if startDateTimeJS is valid
      if (isNaN(startDateTimeJS.getTime())) {
        console.error("Invalid Date or Time:",
            bookingData.selectedDate,
            bookingData.selectedTime,
        );
        return;
      }


      // Email options to send booking details
      const mailOptions = {
        from: "dangonewildbiz@gmail.com",
        to: "dangonewildbiz@gmail.com",
        subject: "New Booking Confirmed",
        html: `
          <p>A new booking has been confirmed:</p>
          <p><strong>Name:</strong> ${bookingData.name}</p>
          <p><strong>Email:</strong> ${bookingData.email}</p>
          <p><strong>Phone Number:</strong> ${bookingData.phoneNumber}</p>
          <p><strong>Location:</strong> ${bookingData.location}</p>
          <p><strong>Selected Date:</strong> ${formattedDate}</p>
          <p><strong>Selected Time:</strong> ${bookingData.selectedTime}</p>
          <p><strong>Event Type:</strong> ${bookingData.eventType}</p>
          <p><strong>Event Description:</strong> ${
  bookingData.eventDescription}
          </p>
          <p><strong>Selected Animals:</strong> ${animalList}</p>
          <p><strong>Confirmation Code:</strong> ${bookingId}</p>
        `,
      };

      // Send the email
      transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
          console.error("Error sending email:", error);
        } else {
          // console.log("Email sent:", info.response);
        }
      });

      // Email options to send a personalized email to the user
      const userMailOptions = {
        from: "dangonewildbiz@gmail.com",
        to: bookingData.email,
        subject: "Dan Gone Wild - Booking Confirmation",
        html: `
          <p>Hey ${bookingData.name}, 
          thank you so much for booking Dan Gone Wild!</p>
          <p>We look forward to seeing you on 
          <strong>${formattedDate} at ${bookingData.selectedTime}</strong> 
          at the following location:</p>
          <p><strong>Location:</strong> ${bookingData.location}</p>
          <p>I'll be bringing over some friends with me: ${animalList}</p>
          <p><strong>Confirmation Code:</strong> ${bookingId}</p>
          <p>
              Please keep this confirmation code for reference if you need to 
              look up or modify your booking.
          </p>
          <p>Look forward to seeing you soon!</p>
        `,
      };

      // Send the personalized user email
      transporter.sendMail(userMailOptions, (error, info) => {
        if (error) {
          console.error("Error sending email to user:", error);
        } else {
          // console.log("User email sent:", info.response);
        }
      });

      // Prepare the event for Google Calendar with adjusted times
      const event = {
        summary: `Animal Show Booking for ${bookingData.name}`,
        location: bookingData.location,
        description: `
          Event Type: ${bookingData.eventType}
          Event Description: ${bookingData.eventDescription}
          Show with animals: ${animalList}
        `,
        start: {
          dateTime: startDateTime.toISO(),
          timeZone: "America/New_York",
        },
        end: {
          dateTime: startDateTime.plus({hours: 1}).toISO(),
          timeZone: "America/New_York",
        },
      };

      // Log the event data to inspect what is being passed to Google Calendar
      // console.log("Event data being sent to Google Calendar:", event);

      // Insert the event into Google Calendar
      calendar.events.insert(
          {calendarId: "dangonewildbiz@gmail.com", resource: event},
          (err, event) => {
            if (err) {
              // console.error("Error creating calendar event:", err);
              return;
            }
            // console.log("Calendar event created:", event.data.htmlLink);
          },
      );
    });

// Google Places API to fetch address suggestions
exports.getPlaceSuggestions = functions.https.onRequest((req, res) => {
  cors(req, res, async () => { // Wrap your function call inside theCORS handler
    const input = req.query.input;
    const GOOGLE_PLACES_API_URL = `https://maps.googleapis.com/maps/api/place/autocomplete/json`;

    // Define the latitude and longitude of the operator's house
    const operatorLat = 28.451988101712825;
    const operatorLon = -81.35313737022665;

    // Define the radius for the location bias (25 miles = 40233.6 meters)
    const radius = 40233.6;

    try {
      const response = await axios.get(GOOGLE_PLACES_API_URL, {
        params: {
          input: input,
          key: googleApiKey,
          types: "geocode",
          language: "en",
          components: "country:us",
          locationbias: `circle:${radius}@${operatorLat},${operatorLon}`,
        },
      });

      // Return the place suggestions to the client
      res.set("Access-Control-Allow-Origin", "*");
      res.json(response.data.predictions);
    } catch (error) {
      console.error("Error fetching Google Place suggestions:", error);
      res.status(500).send("Error fetching suggestions");
    }
  });
});

exports.getPlaceDetailsFromAddress = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    const address = req.query.address;
    const GOOGLE_FIND_PLACE_API_URL = `https://maps.googleapis.com/maps/api/place/findplacefromtext/json`;
    const GOOGLE_PLACE_DETAILS_API_URL = `https://maps.googleapis.com/maps/api/place/details/json`;

    try {
      // Fetch place_id based on the address
      const placeIdResponse = await axios.get(GOOGLE_FIND_PLACE_API_URL, {
        params: {
          input: address,
          inputtype: "textquery",
          fields: "place_id",
          key: googleApiKey,
        },
      });

      // Log the full response for debugging
      console.log("Place ID Response:", placeIdResponse.data);

      if (
        placeIdResponse.data.status !== "OK" ||
          placeIdResponse.data.candidates.length === 0
      ) {
        return res.status(404).json({
          error: "No place ID found for the given address.",
        });
      }
      const placeId = placeIdResponse.data.candidates[0].place_id;

      // Fetch the place details using the place_id
      const placeDetailsResponse = await axios.get(
          GOOGLE_PLACE_DETAILS_API_URL,
          {
            params: {
              place_id: placeId,
              key: googleApiKey,
            },
          });

      // Log the full response for debugging
      console.log("Place Details Response:", placeDetailsResponse.data);

      if (
        placeDetailsResponse.data.status === "OK" &&
          placeDetailsResponse.data.result.geometry
      ) {
        const location = placeDetailsResponse.data.result.geometry.location;
        res.json({
          lat: location.lat,
          lng: location.lng,
        });
      } else {
        res.status(500).json({error: "Place details not found."});
      }
    } catch (error) {
      console.error("Error fetching place details:", error);
      res.status(500).send("Error fetching place details");
    }
  });
});

exports.checkAvailability = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    const {startDate, endDate} = req.body;

    const startDateTime = DateTime.fromISO(
        startDate,
        {zone: "America/New_York"},
    ).startOf("day");

    const endDateTime = DateTime.fromISO(
        endDate,
        {zone: "America/New_York"},
    ).endOf("day");

    try {
      const response = await calendar.events.list({
        calendarId: "dangonewildbiz@gmail.com",
        timeMin: startDateTime.toUTC().toISO(),
        timeMax: endDateTime.toUTC().toISO(),
        singleEvents: true,
        orderBy: "startTime",
      });

      const events = response.data.items;
      const unavailableDates = [];
      const unavailableStartTimes = {};

      // Iterate through each date in the range
      let currentDate = startDateTime;
      while (currentDate <= endDateTime) {
        const dateStr = currentDate.toISODate();

        // Filter out events for the specific day
        const eventsForDay = events.filter((event) => {
          const eventDate = DateTime.fromISO(
              event.start.dateTime || event.start.date,
          ).setZone("America/New_York").toISODate();
          return eventDate === dateStr;
        });

        // console.log(`Processing events for ${dateStr}:`, eventsForDay);

        // Check if there are any all-day events
        const allDayEvents = eventsForDay.filter((event) =>
          event.start.date && event.end.date,
        );

        if (allDayEvents.length > 0) {
          // Convert all-day event date to Eastern Time (ET)
          const allDayETDate = DateTime.fromISO(allDayEvents[0].start.date)
              .setZone("America/New_York", {keepLocalTime: true})
              .toISODate();

          // console.log(`All-day event detected for ${allDayETDate}`);
          // If there are any all-day events, mark the date as fully unavailable
          unavailableDates.push(allDayETDate); // Store the ET date

          // Check the day before the all-day event
          const dayBefore = DateTime.fromISO(allDayEvents[0].start.date)
              .setZone("America/New_York")
              .minus({days: 1})
              .toISODate();

          // console.log(`Checking the day before: ${dayBefore}`);
          // Ensure the day before the all-day event is checked for bookings
          const eventsDayBefore = events.filter((event) => {
            const eventDate = DateTime.fromISO(
                event.start.dateTime || event.start.date,
            )
                .setZone("America/New_York")
                .toISODate();
            return eventDate === dayBefore;
          });

          // console.log(`Events on the day before (${dayBefore}):`,
          // eventsDayBefore);

          // If events exist for the day before, mark the time slots
          if (eventsDayBefore.length > 0) {
            unavailableStartTimes[dayBefore] = eventsDayBefore.map((event) => {
              const eventStartTime = DateTime.fromISO(
                  event.start.dateTime || event.start.date,
              )
                  .setZone("America/New_York")
                  .toISO();
              return eventStartTime;
            });
          }
        }

        // Check if there are regular (non-all-day) events for the current day
        if (eventsForDay.length > 0) {
          unavailableStartTimes[dateStr] = eventsForDay.map((event) => {
            const eventStartTime = DateTime.fromISO(
                event.start.dateTime || event.start.date,
            )
                .setZone("America/New_York")
                .toISO();
            return eventStartTime;
          });
        }

        currentDate = currentDate.plus({days: 1});
      }

      // Return unavailable dates and start times
      res.status(200).send({unavailableDates, unavailableStartTimes});
    } catch (err) {
      console.error("Error checking availability:", err);
      res.status(500).send("Error checking availability");
    }
  });
});

// Function to check specific availability for a single date and time
exports.checkSpecificAvailability = functions.https.onRequest(
    async (req, res) => {
      cors(req, res, async () => {
        const {selectedDate, selectedTime} = req.body;

        // Combine selectedDate and selectedTime into a Luxon DateTime object
        const selectedDateTime = combineDateAndTime(selectedDate, selectedTime);

        try {
        // Query Google Calendar for events on the selected date
          const response = await calendar.events.list({
            calendarId: "dangonewildbiz@gmail.com",
            timeMin: selectedDateTime.toUTC().toISO(),
            // 15-minute slot
            timeMax: selectedDateTime.plus({minutes: 15}).toUTC().toISO(),
            singleEvents: true,
            orderBy: "startTime",
          });

          const events = response.data.items;

          // Check if there are any events during the selected time slot
          const isAvailable = events.length === 0;

          // Send the availability status
          res.status(200).send({isAvailable});
        } catch (err) {
          console.error("Error checking specific availability:", err);
          res.status(500).send("Error checking specific availability");
        }
      });
    },
);
