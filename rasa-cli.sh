docker run -it --rm \
  -v ./rasa:/rasa-home \
  -v ./rasa-cache:/app/.cache \
  --entrypoint /bin/bash \
  rasa-apple
