# Build stage
FROM node:20-alpine as build

WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Production stage with Nginx
FROM nginx:alpine

# Install curl for debugging
RUN apk add --no-cache curl

# Copy built app to nginx html directory
COPY --from=build /app/build /usr/share/nginx/html

# Create nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]