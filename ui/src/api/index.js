import axios from "axios";

const api = axios.create({
  baseURL: `https://${
    typeof GetParentResourceName !== "undefined"
      ? GetParentResourceName()
      : "bcc-wagons"
  }/`,
});

export default api;
