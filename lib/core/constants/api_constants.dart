class ApiConstants {
static final String baseUrl="https://eduspace-platform-production-4062.up.railway.app/api/v1";
 static final String reservationsEndpoint = "/reservations";
  
  static String createReservationPath(String teacherId, String areaId) {
    return "/teachers/$teacherId/areas/$areaId/reservations";
  }}