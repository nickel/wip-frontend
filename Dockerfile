# syntax=docker/dockerfile:1

# STAGE 0: Build
FROM node:22.0.0-alpine3.19

WORKDIR /home/node

RUN npm install -g pnpm

COPY package.json pnpm-lock.yaml .

RUN pnpm install

COPY . .

RUN pnpm build

# STAGE 1: Serve
FROM nginx:1.25.3-alpine

COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=0 /home/node/dist/index.html /usr/share/nginx/html/index.html
COPY --from=0 /home/node/dist/_astro /usr/share/nginx/html/_astro
COPY public/favicon.svg /usr/share/nginx/html/favicon.svg
COPY deploy/404.html /usr/share/nginx/html
