#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

// Replace with your session cookie value
#define BASE_URL "https://adventofcode.com/2024/day/%d/input"

// Callback function to write data to a file
size_t write_data(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    size_t written = fwrite(ptr, size, nmemb, stream);
    return written;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <session_cookie> <day>\n", argv[0]);
        return 1;
    }

    // Parse command line arguments
    int day = atoi(argv[2]);
    if (day < 1 || day > 25) {
        fprintf(stderr, "Invalid day\n");
        return 1;
    }

    char *session_cookie = argv[1];

    CURL *curl;
    CURLcode res;

    // Prepare the URL
    char url[256];
    snprintf(url, sizeof(url), BASE_URL, day); 

    // Prepare the file path
    char file_path[256];
    snprintf(file_path, sizeof(file_path), "inputs/day%d", day);

    // Create the "inputs" directory if it doesn't exist
    if (system("mkdir -p inputs") != 0) {
        perror("Error creating directory");
        return 1;
    }

    FILE *fp = fopen(file_path, "wb");
    if (!fp) {
        perror("Error opening file");
        return 1;
    }

    // Initialize CURL
    curl = curl_easy_init();
    if (curl) {
        // Set URL
        curl_easy_setopt(curl, CURLOPT_URL, url);

        // Set the session cookie in the header
        struct curl_slist *headers = NULL;
        char cookie_header[512];
        snprintf(cookie_header, sizeof(cookie_header), "Cookie: session=%s", session_cookie);
        headers = curl_slist_append(headers, cookie_header);
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

        // Set the User-Agent (optional but recommended)
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "C program for Advent of Code input");

        // Write data to the file
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_data);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, fp);

        // Perform the request
        res = curl_easy_perform(curl);
        if (res != CURLE_OK) {
            fprintf(stderr, "CURL error: %s\n", curl_easy_strerror(res));
        } else {
            printf("Input for day %d successfully saved to %s\n", day, file_path);
        }

        // Clean up
        curl_easy_cleanup(curl);
        curl_slist_free_all(headers);
    } else {
        fprintf(stderr, "Error initializing CURL\n");
    }

    fclose(fp);
    return 0;
}
