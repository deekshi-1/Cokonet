FROM node:14-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY app.js ./

FROM node:22-alpine
WORKDIR /app

COPY --from=builder /app .
RUN chown -R node:node /app

USER node

RUN rm -rf /usr/local/lib/node_modules/npm

EXPOSE 3000
CMD ["node", "app.js"]