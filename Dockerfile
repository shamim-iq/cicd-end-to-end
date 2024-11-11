#FROM python:3
#RUN pip install django==3.2

#COPY . .

#RUN python manage.py migrate
#EXPOSE 8000
#CMD ["python","manage.py","runserver","0.0.0.0:8000"]

# Use an official Python runtime as a parent image
FROM python:3.10

# Set the working directory in the container
WORKDIR /app

# Install dependencies
RUN apt-get update

# Install Django and any other dependencies directly
RUN pip install django==3.2
RUN pip install setuptools

# Copy the application code
COPY . .

# Run migrations
RUN python manage.py migrate

# Expose port 8000
EXPOSE 8000

# Run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]




