-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 29, 2026 at 10:17 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lyza's_boarding_house`
--

-- --------------------------------------------------------

--
-- Table structure for table `payment_history`
--

CREATE TABLE `payment_history` (
  `id` int(11) NOT NULL,
  `reservation_id` int(11) NOT NULL,
  `payment_type` enum('Downpayment','Remaining Balance') NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` enum('GCash','Cash') NOT NULL,
  `payment_status` enum('Pending','Verified','Rejected') NOT NULL DEFAULT 'Pending',
  `receipt_path` varchar(255) DEFAULT NULL,
  `verified_by` int(11) DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `move_in_date` date NOT NULL,
  `notes` text DEFAULT NULL,
  `payment_method` enum('GCash') NOT NULL DEFAULT 'GCash',
  `status` enum('Pending','Approved','Confirmed','Cancelled') NOT NULL DEFAULT 'Pending',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `downpayment_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `remaining_balance` decimal(10,2) NOT NULL DEFAULT 0.00,
  `remaining_balance_paid` decimal(10,2) NOT NULL DEFAULT 0.00,
  `remaining_balance_payment_method` enum('Cash','GCash') DEFAULT NULL,
  `remaining_balance_paid_at` datetime DEFAULT NULL,
  `downpayment_proof` varchar(255) DEFAULT NULL,
  `downpayment_proof_at` datetime DEFAULT NULL,
  `downpayment_confirmed_at` datetime DEFAULT NULL,
  `assigned_staff` int(11) DEFAULT NULL,
  `downpayment_verified_by` int(11) DEFAULT NULL,
  `reservation_approved_by` int(11) DEFAULT NULL,
  `reservation_approved_at` datetime DEFAULT NULL,
  `move_in_confirmed_by` int(11) DEFAULT NULL,
  `move_in_confirmed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `id` int(11) NOT NULL,
  `room_number` varchar(20) NOT NULL,
  `room_type` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `downpayment_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `inclusions` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `status` enum('Available','Reserved','Occupied') NOT NULL DEFAULT 'Available',
  `archived` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`id`, `room_number`, `room_type`, `price`, `downpayment_amount`, `description`, `inclusions`, `image`, `status`, `archived`) VALUES
(1, '01', 'Single Room', 2500.00, 500.00, 'Budget-friendly solo room with bed, cabinet, and wall fan — with two common CR. Shared refrigerator (₱50/month), coin-operated stove, and coin-operated water dispenser available. Perfect for students or workers!', 'Free Wifi\nFree Water\nFree 10kwh Electricity (Own Submeter)', '37cb122f-0616-43fc-8c34-57cd93cd2b74.jpg', 'Available', 0);

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `setting_key`, `setting_value`) VALUES
(1, 'gcash_account_name', ''),
(2, 'gcash_account_number', ''),
(3, 'gcash_qr_image', ''),
(4, 'payment_instructions', ''),
(5, 'minimum_stay_months', '12'),
(6, 'reservation_policy', ''),
(7, 'move_in_requirements', ''),
(8, 'cancellation_policy', '');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `contact` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('guest','tenant','admin','staff') NOT NULL DEFAULT 'guest',
  `status` enum('Active','Inactive') NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `contact`, `password`, `role`, `status`) VALUES
(1, 'Lyza', 'Admin', 'admin@lyzas.com', NULL, '$2a$12$FCwo8jTVTXXUC0TB9KpSHOo4Ltkhr9ieTnu6w0mnwtPU7gVoHNGMW', 'admin', 'Active');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `payment_history`
--
ALTER TABLE `payment_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_payment_reservation` (`reservation_id`),
  ADD KEY `fk_payment_verifier_user` (`verified_by`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_reservation_user` (`user_id`),
  ADD KEY `fk_reservation_room` (`room_id`),
  ADD KEY `fk_assigned_staff` (`assigned_staff`),
  ADD KEY `fk_payment_verifier` (`downpayment_verified_by`),
  ADD KEY `fk_reservation_approver` (`reservation_approved_by`),
  ADD KEY `fk_move_in_confirmer` (`move_in_confirmed_by`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `room_number` (`room_number`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `unique_user_email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `payment_history`
--
ALTER TABLE `payment_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `payment_history`
--
ALTER TABLE `payment_history`
  ADD CONSTRAINT `fk_payment_reservation` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`),
  ADD CONSTRAINT `fk_payment_verifier_user` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `fk_assigned_staff` FOREIGN KEY (`assigned_staff`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_move_in_confirmer` FOREIGN KEY (`move_in_confirmed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_payment_verifier` FOREIGN KEY (`downpayment_verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_reservation_approver` FOREIGN KEY (`reservation_approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_reservation_room` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`),
  ADD CONSTRAINT `fk_reservation_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
