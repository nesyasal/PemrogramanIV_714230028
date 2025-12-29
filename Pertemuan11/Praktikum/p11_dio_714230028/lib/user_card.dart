import 'package:flutter/material.dart';
import 'user.dart';

class UserCard extends StatelessWidget {
  final UserCreate usrCreate;

  const UserCard({super.key, required this.usrCreate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.lightBlue[200],
      ),
      child: Column(
        children: [
          _buildRow('ID', ': ${usrCreate.id}'),
          _buildRow('Name', ': ${usrCreate.name}'),
          _buildRow('Job', ': ${usrCreate.job}'),
          _buildRow('Created At', ': ${usrCreate.createdAt}'),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80, 
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}

class PutCard extends StatelessWidget {
  final UserUpdate usrUpdate;

  const PutCard({super.key, required this.usrUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.orange[200], 
      ),
      child: Column(
        children: [
          _buildRow('Name', ': ${usrUpdate.name}'),
          _buildRow('Job', ': ${usrUpdate.job}'),
          _buildRow('Updated At', ': ${usrUpdate.updatedAt}'),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90, 
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
