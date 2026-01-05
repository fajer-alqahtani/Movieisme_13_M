# Movieisme 🎬

Movieisme is an iOS application built using **SwiftUI** that allows users to explore movies, view details, and interact with ratings and reviews.  
The app integrates with an external API (Airtable) to manage data dynamically.

---

## CRUD Operations & API Integration

The app implements full **CRUD (Create, Read, Update)** functionality using a RESTful API powered by **Airtable**, integrated through `URLSession`.

### 🔹 Create
- Users can add new reviews for a movie.
- Review data (rating, review text, user reference, and movie reference) is sent to the API using a **POST** request.
- Data is encoded using `Encodable` models before being sent.

### 🔹 Read
- Movie details and reviews are fetched from the API using **GET** requests.
- Reviews are filtered by movie using Airtable `filterByFormula`.
- The app dynamically calculates the average rating based on fetched reviews.
- Data is decoded into strongly typed Swift models using `Decodable`.

### 🔹 Update
- User profile data (such as name or profile image) can be updated.
- Updates are sent using **PATCH** requests to modify existing records in Airtable.
- Only changed fields are included in the request body.

## API Integration Details

- **Networking:** URLSession
- **API Type:** REST API
- **Authentication:** Bearer Token (Airtable Personal Access Token)
- **Architecture:** MVVM
- **Error Handling:**  
  - HTTP status code validation  
  - Decoding error handling  
