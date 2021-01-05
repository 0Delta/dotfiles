FROM {{_input_:FROM_image}}
LABEL maintainer "0Δ (0deltast@gmali.com)>"

WORKDIR /root/src
RUN {{_cursor_}}

ENTRYPOINT ["/bin/bash"]
CMD [""]
