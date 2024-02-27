# Use an official Node runtime as a parent image
FROM node:20-bullseye

ARG PUBLIC_APPWRITE_COL_MESSAGES_ID
ENV PUBLIC_APPWRITE_COL_MESSAGES_ID ${PUBLIC_APPWRITE_COL_MESSAGES_ID}

ARG PUBLIC_APPWRITE_COL_THREADS_ID
ENV PUBLIC_APPWRITE_COL_THREADS_ID ${PUBLIC_APPWRITE_COL_THREADS_ID}

ARG PUBLIC_APPWRITE_DB_MAIN_ID
ENV PUBLIC_APPWRITE_DB_MAIN_ID ${PUBLIC_APPWRITE_DB_MAIN_ID}

ARG PUBLIC_APPWRITE_FN_TLDR_ID
ENV PUBLIC_APPWRITE_FN_TLDR_ID ${PUBLIC_APPWRITE_FN_TLDR_ID}

ARG PUBLIC_APPWRITE_PROJECT_ID
ENV PUBLIC_APPWRITE_PROJECT_ID ${PUBLIC_APPWRITE_PROJECT_ID}

ARG PUBLIC_APPWRITE_PROJECT_INIT_ID
ENV PUBLIC_APPWRITE_PROJECT_INIT_ID ${PUBLIC_APPWRITE_PROJECT_INIT_ID}

ARG APPWRITE_DB_INIT_ID
ENV APPWRITE_DB_INIT_ID ${APPWRITE_DB_INIT_ID}

ARG APPWRITE_COL_INIT_ID
ENV APPWRITE_COL_INIT_ID ${APPWRITE_COL_INIT_ID}

ARG APPWRITE_API_KEY_INIT
ENV APPWRITE_API_KEY_INIT ${APPWRITE_API_KEY_INIT}

ARG GITHUB_TOKEN
ENV GITHUB_TOKEN ${GITHUB_TOKEN}

ARG VERSION
ENV VERSION ${VERSION}

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

WORKDIR /app
COPY . .

# Remove the node_modules folder to avoid wrong binaries
RUN rm -rf node_modules

# Install fontconfig
COPY ./local-fonts /usr/share/fonts
RUN apt-get update; apt-get install -y fontconfig
RUN fc-cache -f -v

RUN corepack enable
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
RUN NODE_OPTIONS=--max_old_space_size=8192 pnpm run build

EXPOSE 3000

CMD [ "node", "server/main.js"]