
Debuggers behave differently with privileged processes to prevent unprivileged ones to prevent security attacks. unprivileged users could debug privileged programs, they could easily take control of the whole system

![[Pasted image 20260623050701.png]]
![[Pasted image 20260623051123.png]]

-rwsr-xr-x  1 grader grader  16360 May 31 01:38 win

![[Pasted image 20260623051535.png]]


[hacker22@warhead chal5]$ cat sun_reversed.c
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <pwd.h>
#include <grp.h>
#include <ctype.h>
#include <time.h>
#include <errno.h>
#include <sys/wait.h>

#define CONFIG_FILE "/usr/local/share/sun.ini"

#define MAX_LEN 1024
#define IO_CHUNK 512

struct config {
    char processor[MAX_LEN];
    uid_t user;
    gid_t group;
    long long hydrogen;
};

void die(const char *msg) {
    printf("%s\n", msg);
    exit(EXIT_FAILURE);
}

void parser_die(const char *msg, char *line) {
    printf("Error on line:\n -> %s\n", line);
    printf("%s\n", msg);
    exit(EXIT_FAILURE);
}

char *strip(char *s) {
    int first;
    int last;
    int i;

    if (s == NULL) {
        return NULL;
    }

    last = strlen(s) - 1;
    if (last < 0) {
        return s;
    }

    while (isspace(s[last])) {
        --last;
    }

    first = 0;
    while (isspace(s[first])) {
        ++first;
    }

    for (i = 0; i < (last - first + 1); ++i) {
        s[i] = s[first + i];
    }
    s[i] = '\0';

    return s;
}

struct config *parse_config(struct config *conf) {
    FILE *f;
    char line[MAX_LEN];
    char tmp[MAX_LEN];
    char *t;
    char *l;
    char *key;
    char *value;
    struct passwd *pw;
    struct group *gr;
    char *endptr;

    int in_section = 0;
    int processor_seen = 0 ;
    int user_seen = 0 ;
    int group_seen = 0 ;
    int hydrogen_seen = 0;

    f = fopen(CONFIG_FILE, "r");
    if (f == NULL) {
        die("Cannot open configuration file");
    }

    while (1) {
        if (fgets(line, MAX_LEN, f) == NULL) {
            break;
        }

        l = strip(line);
        if (l[0] == '\0' || l[0] == '#') {
            continue;
        }

        if (l[0] == '[' && l[strlen(l) - 1] == ']') {
            if (strcmp(l, "[sun]") == 0) {
                in_section = 1;
                continue;
            } else {
                parser_die("Unknown section", line);
            }
        }

        if (in_section == 0) {
            parser_die("Not inside a valid [sun] section", line);
        }

        strcpy(tmp, l);

        t = tmp;
        key = strip(strsep(&t, "="));
        value = strip(strsep(&t, "="));

        if (key == NULL || value == NULL ||
            key[0] == '\0' || value[0] == '\0' ||
            strip(t) != NULL) {
            parser_die("Bad key = value pair", line);
        }

        if (value[0] != '"' || value[strlen(value) - 1] != '"') {
            parser_die("Value quoting error", line);
        }

        value[strlen(value) - 1] = '\0';
        value = value + 1;

        if (strchr(value, '"') != NULL) {
            parser_die("Value quoting error", line);
        }

        if (strcmp(key, "processor") == 0) {
            if (processor_seen == 0) {
                strcpy(conf->processor, value);
                processor_seen = 1;
            } else {
                parser_die("Duplicate key", line);
            }
        } else if (strcmp(key, "user") == 0) {
            if (user_seen == 0) {
                pw = getpwnam(value);
                if (pw == NULL) {
                    parser_die("No such user", line);
                }
                conf->user = pw->pw_uid;

                user_seen = 1;
            } else {
                parser_die("Duplicate key", line);
            }
        } else if (strcmp(key, "group") == 0) {
            if (group_seen == 0) {
                gr = getgrnam(value);
                if (gr == NULL) {
                    parser_die("No such group", line);
                }
                conf->group = gr->gr_gid;

                group_seen = 1;
            } else {
                parser_die("Duplicate key", line);
            }
        } else if (strcmp(key, "hydrogen") == 0) {
            if (hydrogen_seen == 0) {
                errno = 0;
                conf->hydrogen = strtoll(value, &endptr, 10);
                if (errno == ERANGE || endptr == value || *endptr != '\0') {
                    parser_die("Invalid year", line);
                }

                hydrogen_seen = 1;
            } else {
                parser_die("Duplicate key", line);
            }
        } else {
            parser_die("Unknown key", line);
        }
    }

    if (processor_seen == 0 || user_seen == 0 || group_seen == 0 || hydrogen_seen == 0) {
        die("Missing configuration fields, bailing out");
    }

    fclose(f);

    return conf;
}

char *read_file(char *buf, char *path) {
    int f;
    unsigned count;
    unsigned cur;
    unsigned max;

    f = open(path, O_RDONLY);
    if (f == -1)
        die("Cannot open file");

    cur = 0;
    max = IO_CHUNK;
    while ((count = read(f, buf + cur, IO_CHUNK))){
        if (count == -1)
            die("Cannot read file");

        cur += count;
    }
    close(f);
}

void it_is_time(struct config *conf, char *buf) {
    pid_t pid;
    int status;
    char *dup;
    char *base;
    int pipe_to_parent[2];
    int pipe_to_child[2];
    ssize_t count;

    if((pipe(pipe_to_parent) == -1) || (pipe(pipe_to_child) == -1)) {
        die("Cannot create pipe");
    }

    pid = fork();
    if (pid == -1) {
        die("Cannot fork");
    }

    if (pid == 0) {
        dup2(pipe_to_child[0], STDIN_FILENO);
        dup2(pipe_to_parent[1], STDOUT_FILENO);
        close(pipe_to_parent[0]);
        close(pipe_to_parent[1]);
        close(pipe_to_child[0]);
        close(pipe_to_child[1]);

        dup = strdup(conf->processor); /* No free() because of exec. */
        base = basename(dup);

        if(seteuid(conf->user) == -1) {
            printf("Trying new effective user: %d\n", conf->user);
            die("Cannot adjust user privileges, check configuration");
        }
        if(setegid(conf->group) == -1) {
            printf("Trying new effective group: %d\n", conf->group);
            die("Cannot adjust group privileges, check configuration");
        }

        execl(conf->processor, base, NULL);

        die("Cannot locate The Processor, check configuration");
    }

    close(pipe_to_child[0]);
    close(pipe_to_parent[1]);

    write(pipe_to_child[1], buf, MAX_LEN);
    close(pipe_to_child[1]);

    if (wait(&status) == pid) {
        if (WIFEXITED(status)) {
            count = read(pipe_to_parent[0], buf, MAX_LEN);
            if (count == -1) {
                die("The Processor failed prematurely");
            }

            buf[count] = '\0';
            close(pipe_to_parent[0]);

            if (WEXITSTATUS(status) == EXIT_SUCCESS) {
                printf("\"%s\"\n        - The Processor\n", buf);
            } else{
                puts(buf); /* Also captures a child error before exec. */
            }
        } else {
            die("The Processor failed prematurely");
        }
    } else {
        die("Cannot wait on The Processor");
    }

    return;
}

void check_sun(struct config *conf, char *buf) {
    time_t ts;
    char *r;
    long long cur_year;

    time(&ts);
    cur_year = localtime(&ts)->tm_year + 1900;

    if (cur_year >= conf->hydrogen) {
        it_is_time(conf, buf);
        exit(EXIT_SUCCESS);
    }

    puts("This program only works after the sun's core hydrogen exhaustion.");
    printf("Please try again in roughly %lld years.\n", conf->hydrogen - cur_year);
}

int main(int argc, char **argv) {
    struct config conf;
    char buf[MAX_LEN];
    gid_t rgid;
    gid_t egid;
    gid_t sgid;

    if (argc != 2) {
        printf("usage: %s <input-file-path>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    if(getresgid(&rgid, &egid, &sgid) != 0) {
        die("Cannot get GIDs. This shouldn't happen. Let Kaan know ASAP");
    }

    if(setegid(rgid) != 0) {
        die("Cannot drop privileges. This shouldn't happen. Let Kaan know ASAP");
    }

    parse_config(&conf);

    read_file(buf, argv[1]);

    check_sun(&conf, buf);

    return EXIT_SUCCESS;
}
[hacker22@warhead chal5]$