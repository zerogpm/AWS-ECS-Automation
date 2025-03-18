FROM node:20-alpine

RUN apk add --no-cache curl

WORKDIR /app

COPY . .

RUN npm install --omit=dev

EXPOSE 5000

CMD ["npm", "start"]