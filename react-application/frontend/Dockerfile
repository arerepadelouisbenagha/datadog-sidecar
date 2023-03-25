# FROM node:14-alpine

# WORKDIR /usr/src/app/

# COPY package*.json /usr/src/app/
# COPY . /usr/src/app/

# RUN npm install
# RUN npm install vue-basic-alert

# EXPOSE 8080
# CMD ["npm", "run", "serve"]

# Build stage
FROM node:14-alpine as build

WORKDIR /usr/src/app/

COPY package*.json /usr/src/app/
COPY . /usr/src/app/

RUN npm install
RUN npm install vue-basic-alert

# Production stage
FROM nginx:1.21
COPY --from=build /usr/src/app /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
