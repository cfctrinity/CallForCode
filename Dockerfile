# base image for build environment
FROM node:12.2.0-alpine as build
# set working directory
WORKDIR /app
# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH
# install and cache app dependencies
RUN npm config set unsafe-perm true
COPY package*.json /app/
RUN npm config set unsafe-perm true
RUN npm install
RUN npm install react-scripts -g
# Bundle app source
COPY . /app
RUN npm run build

# Production environment
FROM nginx:1.16.0-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]