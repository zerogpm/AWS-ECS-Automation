FROM node:20-alpine

# Install curl for debugging
RUN apk add --no-cache curl

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 5000

CMD ["npm", "run", "dev"]