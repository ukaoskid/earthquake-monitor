process_dataset <- function(filtered_ds) {
    
    eq_dataset_01 <<- eq_filtered %>%
        group_by(time = format(eq_filtered$Time, "%Y-%m-%d")) %>%
        summarize(
            shake_mean = round(mean(Magnitude), 1),
            max_magnitude = max(Magnitude),
            from_2_to_3_9 = sum(Magnitude >= 2 & Magnitude <= 3.9),
            from_4_to_5_9 = sum(Magnitude >= 4 & Magnitude <= 5.9),
            from_6_to_6_9 = sum(Magnitude >= 6 & Magnitude <= 6.9),
            from_7_to_7_9 = sum(Magnitude >= 7 & Magnitude <= 7.9),
            from_8_to_8_9 = sum(Magnitude >= 8 & Magnitude <= 8.9),
            from_9_to_10 = sum(Magnitude >= 9 & Magnitude <= 10)
        )
}