# base
FROM node:22-alpine AS base
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .

# test
FROM base AS test
RUN npm run test

# dev
FROM base AS dev 
EXPOSE 3000
CMD ["npm", "run", "dev"]

# build
FROM base AS build
RUN npm run build

# prod
FROM nginx:stable-alpine AS production
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]





# v02 - Prueba