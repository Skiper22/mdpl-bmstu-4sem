#include <gtk/gtk.h>
#include <stdio.h>
#include <string.h>

GtkWidget *sum_label;
GtkWidget *x_label;
GtkWidget *x_entry;
GtkWidget *y_label;
GtkWidget *y_entry;
GtkWidget *enterbutton;

void enter_callback(GSimpleAction *action, GVariant *parameter, gpointer data) {
    char str[50];
    const char *x_str = gtk_entry_get_text(x_entry);
    const char *y_str = gtk_entry_get_text(y_entry);

    int sum = atoi(x_str) + atoi(y_str);
    sprintf(str,"sum = %d", sum);
    gtk_label_set_text(sum_label,(const char *)str);
}

static void activate(GtkApplication *app) {
    // map menu actions to callbacks
    const GActionEntry app_actions[] = {
            { "enter", enter_callback, NULL, NULL, NULL },
    };

    // create a window with title, default size and icons
    GtkWidget *window = gtk_application_window_new(app);
    gtk_window_set_application((window), (app));
    gtk_window_set_title((window),"Calculator app");
    gtk_window_set_position((window), GTK_WIN_POS_CENTER);
    gtk_window_set_resizable((window),FALSE);
    GtkWidget *grid = gtk_grid_new();
    gtk_container_add(window,grid);

    // sum label
    sum_label = gtk_label_new_with_mnemonic("sum = 0");
    gtk_grid_attach(grid,sum_label,0,0,4,1);

    // x entry
    x_label = gtk_label_new_with_mnemonic("x");
    gtk_grid_attach(grid,x_label,0,1,1,1);

    x_entry = gtk_entry_new();
    gtk_entry_set_placeholder_text(x_entry, "0");
    gtk_grid_attach(grid,x_entry,1,1,1,1);
    g_signal_connect(x_entry, "activate", enter_callback, NULL);

    // y entry
    y_label = gtk_label_new_with_mnemonic("y");
    gtk_grid_attach(grid,y_label,2,1,1,1);

    y_entry = gtk_entry_new();
    gtk_entry_set_placeholder_text(y_entry, "0");
    gtk_grid_attach(grid,y_entry,3,1,1,1);
    g_signal_connect(y_entry, "activate", enter_callback, NULL);

    // create Enter buttons
    enterbutton = gtk_button_new_with_label("calculate");
    gtk_grid_attach(grid,enterbutton,0,2,4,1);
    gtk_actionable_set_action_name(enterbutton, "app.enter");

    // connect actions with callbacks
    g_action_map_add_action_entries(app, app_actions, (gint)app_actions, NULL);

    gtk_widget_show_all(window);
}

int main(int argc, char **argv) {
    GtkApplication *app = gtk_application_new("org.gtk.example",0);
    g_signal_connect(app, "activate", activate, NULL);
    g_application_run(app, 0, NULL);
}
