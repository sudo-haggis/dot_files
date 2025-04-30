import os
import sys
from datetime import datetime, timedelta

# Test function with docstring for hover documentation
def calculate_future_date(days_to_add: int) -> datetime:
    """
    Calculate a future date by adding a specified number of days to today.
    
    Args:
        days_to_add: Number of days to add to the current date
        
    Returns:
        A datetime object representing the future date
    """
    today = datetime.now()
    future = today + timedelta(days=days_to_add)
    return future

# Class to test completion and documentation
class DataProcessor:
    def __init__(self, data_source: str):
        """
        Initialize a data processor with a source.
        
        Args:
            data_source: Path to the data source
        """
        self.data_source = data_source
        self.data = None
    
    def load_data(self):
        """Load data from the data source."""
        if os.path.exists(self.data_source):
            with open(self.data_source, 'r') as f:
                self.data = f.read()
    
    def process_data(self, filter_func=None):
        """
        Process the loaded data, optionally applying a filter.
        
        Args:
            filter_func: Optional function to filter data
        
        Returns:
            Processed data
        """
        if self.data is None:
            self.load_data()
        
        # Test auto-completion by typing: result = self.data.
        result = self.data
        
        if filter_func:
            result = filter_func(result)
        
        return result

# Test the functionality
# To test hovering: place cursor over calculate_future_date and press K
future = calculate_future_date(10)
print(f"Future date: {future}")

# To test completion: 
# 1. Type "processor = DataProcessor(" and check for parameter hints
# 2. Type "processor." and check for method suggestions
processor = DataProcessor("sample.txt")

# To test go to definition:
# Place cursor on DataProcessor and press gd
processor.load_data()

# Test os module completion:
# Type "os." and see completion options
current_dir = os.getcwd()
