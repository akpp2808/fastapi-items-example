FROM python:3.8.19-slim

# create new dir and use it as workdir
WORKDIR /code

#RUN apt update
#RUN apt install -y curl

# There's an important trick, first copy the file with the dependencies alone, not the rest of the code
# The file won't change frequently. So, by copying only that file, Docker will use the cache for that step
COPY ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

#RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
 # --no-cache-dir - not save the packages locally, will make image smaller
# --upgrade - install the certain version from the file

# Make port 8000 available to the world outside this container
EXPOSE 8000
EXPOSE 5678

# put this near the end, to optimize the container image build times
COPY .env.docker_example /code/.env
COPY ./api /code/api




#CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
CMD ["python", "-m", "debugpy", "--wait-for-client", "--listen", "0.0.0.0:5678", "-m", "uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000","--reload"]
