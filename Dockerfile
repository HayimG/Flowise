# Build local monorepo image
# docker build --no-cache -t  flowise .
    7|   FROM node:20-alpine
    8|>>>RUN apk add --no-cache libc6-compat=1.2.13-r0 python3=3.9.7-r0 make=4.3-r0 g++=10.3.0-r0
    9|   # needed for pdfjs-dist
   10|   RUN apk add --no-cache build-base cairo-dev pango-dev
   11|   
   12|   # Install Chromium
   13|   RUN apk add --no-cache chromium=1.3.0-r0

# Install curl for container-level health checks
# Fixes: https://github.com/FlowiseAI/Flowise/issues/4126
RUN apk add --no-cache curl

#install PNPM globaly
RUN npm install -g pnpm

ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

ENV NODE_OPTIONS=--max-old-space-size=8192

WORKDIR /usr/src

# Copy app source
COPY . .

RUN pnpm install

RUN pnpm build

EXPOSE 3000

CMD [ "pnpm", "start" ]
